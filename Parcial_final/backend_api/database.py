import sqlite3

DB_NAME = "tienda.db"

def get_connection():
    conn = sqlite3.connect(DB_NAME)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    conn = get_connection()
    cursor = conn.cursor()

    # Tabla de usuarios (campos exigidos en el registro)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            apellidos TEXT NOT NULL,
            username TEXT UNIQUE NOT NULL,
            correo TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
        )
    """)

    # Tabla de productos
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS productos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            categoria TEXT NOT NULL,
            descripcion TEXT NOT NULL,
            precio REAL NOT NULL,
            imagen TEXT NOT NULL
        )
    """)

    # Insertar productos de ejemplo si está vacía
    cursor.execute("SELECT COUNT(*) FROM productos")
    if cursor.fetchone()[0] == 0:
        productos_iniciales = [
            (
                "Audífonos Bluetooth Pro",
                "Electrónica",
                "Cancelación de ruido activa, batería de 24 horas y sonido envolvente.",
                180000,
                "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500"
            ),
            (
                "Camiseta Básica Algodón",
                "Ropa",
                "Camiseta 100% algodón orgánico, corte regular y tela transpirable.",
                45000,
                "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500"
            ),
            (
                "Reloj Inteligente Fit",
                "Electrónica",
                "Monitor de ritmo cardíaco, resistente al agua y notificaciones en pantalla.",
                250000,
                "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500"
            ),
            (
                "Chaqueta Impermeable",
                "Ropa",
                "Ideal para clima frío y lluvia ligera, con bolsillos con cremallera.",
                135000,
                "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500"
            ),
            (
                "Lámpara de Escritorio LED",
                "Hogar",
                "Luz cálida y fría regulable, brazo flexible y bajo consumo energético.",
                68000,
                "https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=500"
            ),
            (
                "Tenis Deportivos Runner",
                "Calzado",
                "Suela amortiguada de alta resistencia para correr o uso diario.",
                210000,
                "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500"
            ),
        ]
        cursor.executemany(
            "INSERT INTO productos (nombre, categoria, descripcion, precio, imagen) VALUES (?, ?, ?, ?, ?)",
            productos_iniciales
        )

    conn.commit()
    conn.close()