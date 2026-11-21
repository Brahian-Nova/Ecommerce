from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import jwt
import datetime
import sqlite3
from database import get_connection, init_db

app = FastAPI(title="API E-Commerce")

# Permitir peticiones desde Flutter (Web, Emulador o Celular)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

SECRET_KEY = "clave_secreta_uniminuto"

# Inicializar base de datos al arrancar
init_db()

# --- Esquemas de datos ---
class RegistroRequest(BaseModel):
    nombre: str
    apellidos: str
    username: str
    correo: str
    password: str

class LoginRequest(BaseModel):
    usuario: str  # Puede ser username o correo[cite: 2]
    password: str

class RecuperarRequest(BaseModel):
    correo: str
    nueva_password: str

class ActualizarPerfilRequest(BaseModel):
    nombre: str
    apellidos: str
    username: str
    password: str = ""

# --- Rutas / Endpoints ---

@app.get("/")
def root():
    return {"mensaje": "API E-Commerce funcionando correctamente"}

@app.post("/registro")
def registrar_usuario(datos: RegistroRequest):
    conn = get_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            "INSERT INTO usuarios (nombre, apellidos, username, correo, password) VALUES (?, ?, ?, ?, ?)",
            (datos.nombre, datos.apellidos, datos.username, datos.correo, datos.password)
        )
        conn.commit()
        return {"mensaje": "Usuario registrado con éxito"}
    except sqlite3.IntegrityError:
        raise HTTPException(status_code=400, detail="El username o correo ya está registrado")
    finally:
        conn.close()

@app.post("/login")
def iniciar_sesion(datos: LoginRequest):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "SELECT * FROM usuarios WHERE (username = ? OR correo = ?) AND password = ?",
        (datos.usuario, datos.usuario, datos.password)
    )
    user = cursor.fetchone()
    conn.close()

    if not user:
        raise HTTPException(status_code=401, detail="Usuario o contraseña incorrectos")

    # Generar token JWT[cite: 2]
    payload = {
        "user_id": user["id"],
        "username": user["username"],
        "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=24)
    }
    token = jwt.encode(payload, SECRET_KEY, algorithm="HS256")

    return {
        "mensaje": "Inicio de sesión exitoso",
        "token": token,
        "usuario": {
            "id": user["id"],
            "nombre": user["nombre"],
            "apellidos": user["apellidos"],
            "username": user["username"],
            "correo": user["correo"]
        }
    }

@app.post("/recuperar-password")
def recuperar_password(datos: RecuperarRequest):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM usuarios WHERE correo = ?", (datos.correo,))
    user = cursor.fetchone()

    if not user:
        conn.close()
        raise HTTPException(status_code=404, detail="No existe una cuenta con ese correo")

    cursor.execute(
        "UPDATE usuarios SET password = ? WHERE correo = ?",
        (datos.nueva_password, datos.correo)
    )
    conn.commit()
    conn.close()
    return {"mensaje": "Contraseña actualizada correctamente"}

@app.get("/productos")
def listar_productos():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM productos")
    filas = cursor.fetchall()
    conn.close()

    productos = [dict(fila) for fila in filas]
    return {"productos": productos}

@app.put("/perfil/{user_id}")
def actualizar_perfil(user_id: int, datos: ActualizarPerfilRequest):
    conn = get_connection()
    cursor = conn.cursor()
    try:
        if datos.password.strip() != "":
            cursor.execute(
                "UPDATE usuarios SET nombre = ?, apellidos = ?, username = ?, password = ? WHERE id = ?",
                (datos.nombre, datos.apellidos, datos.username, datos.password, user_id)
            )
        else:
            cursor.execute(
                "UPDATE usuarios SET nombre = ?, apellidos = ?, username = ? WHERE id = ?",
                (datos.nombre, datos.apellidos, datos.username, user_id)
            )
        conn.commit()
        return {"mensaje": "Perfil actualizado correctamente"}
    except sqlite3.IntegrityError:
        raise HTTPException(status_code=400, detail="Ese username ya está en uso")
    finally:
        conn.close()