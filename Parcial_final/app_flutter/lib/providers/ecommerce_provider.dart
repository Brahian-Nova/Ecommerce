import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class EcommerceProvider extends ChangeNotifier {
  // Cambia a 'http://10.0.2.2:8000' si usas Emulador Android
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8000'));

  // Variables de sesión y JWT
  String? token;
  Map<String, dynamic>? usuarioActual;

  // Variables de productos
  List<dynamic>? productos;
  Map<String, dynamic>? productoSeleccionado;

  // Variables del carrito
  List<Map<String, dynamic>> carrito = [];

  // 1. Iniciar sesión (POST /login)
  Future<String?> login(String usuario, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'usuario': usuario,
        'password': password,
      });

      if (response.statusCode == 200) {
        token = response.data['token'];
        usuarioActual = response.data['usuario'];
        notifyListeners();
        return null; // null significa que no hubo error
      }
      return 'Error al iniciar sesión';
    } on DioException catch (e) {
      print('Error en login: ${e.message}');
      if (e.response != null && e.response?.data['detail'] != null) {
        return e.response?.data['detail'];
      }
      return 'No se pudo conectar con el servidor';
    }
  }

  // 2. Registrar usuario (POST /registro)
  Future<String?> registrar(
    String nombre,
    String apellidos,
    String username,
    String correo,
    String password,
  ) async {
    try {
      final response = await _dio.post('/registro', data: {
        'nombre': nombre,
        'apellidos': apellidos,
        'username': username,
        'correo': correo,
        'password': password,
      });

      if (response.statusCode == 200) {
        return null;
      }
      return 'Error al registrar usuario';
    } on DioException catch (e) {
      print('Error en registro: ${e.message}');
      if (e.response != null && e.response?.data['detail'] != null) {
        return e.response?.data['detail'];
      }
      return 'No se pudo conectar con el servidor';
    }
  }

  // 3. Recuperar contraseña (POST /recuperar-password)
  Future<String?> recuperarPassword(String correo, String nuevaPassword) async {
    try {
      final response = await _dio.post('/recuperar-password', data: {
        'correo': correo,
        'nueva_password': nuevaPassword,
      });

      if (response.statusCode == 200) {
        return null;
      }
      return 'Error al restablecer contraseña';
    } on DioException catch (e) {
      print('Error en recuperar: ${e.message}');
      if (e.response != null && e.response?.data['detail'] != null) {
        return e.response?.data['detail'];
      }
      return 'No se pudo conectar con el servidor';
    }
  }

  // 4. Obtener productos de la API (GET /productos)
  Future<void> getProductos() async {
    try {
      final response = await _dio.get('/productos');
      if (response.statusCode == 200) {
        print(response.data);
        productos = response.data['productos'];
        notifyListeners();
      }
    } on DioException catch (e) {
      print('Error al traer productos: ${e.message}');
      productos = [];
      notifyListeners();
    }
  }

  // 5. Actualizar perfil (PUT /perfil/{id})
  Future<String?> actualizarPerfil(
    String nombre,
    String apellidos,
    String username,
    String password,
  ) async {
    if (usuarioActual == null) return 'No hay sesión activa';
    int id = usuarioActual!['id'];

    try {
      final response = await _dio.put('/perfil/$id', data: {
        'nombre': nombre,
        'apellidos': apellidos,
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        usuarioActual!['nombre'] = nombre;
        usuarioActual!['apellidos'] = apellidos;
        usuarioActual!['username'] = username;
        notifyListeners();
        return null;
      }
      return 'Error al actualizar perfil';
    } on DioException catch (e) {
      print('Error en perfil: ${e.message}');
      if (e.response != null && e.response?.data['detail'] != null) {
        return e.response?.data['detail'];
      }
      return 'No se pudo conectar con el servidor';
    }
  }

  // 6. Seleccionar producto para ver su detalle
  void seleccionarProducto(Map<String, dynamic> producto) {
    productoSeleccionado = producto;
    notifyListeners();
  }

  // 7. Lógica del Carrito
  void agregarAlCarrito(Map<String, dynamic> producto, int cantidad) {
    bool existe = false;
    for (int i = 0; i < carrito.length; i++) {
      if (carrito[i]['id'] == producto['id']) {
        carrito[i]['cantidad'] = carrito[i]['cantidad'] + cantidad;
        existe = true;
      }
    }

    if (!existe) {
      carrito.add({
        'id': producto['id'],
        'nombre': producto['nombre'],
        'precio': producto['precio'],
        'imagen': producto['imagen'],
        'cantidad': cantidad,
      });
    }
    notifyListeners();
  }

  void cambiarCantidadCarrito(int index, int delta) {
    carrito[index]['cantidad'] = carrito[index]['cantidad'] + delta;
    if (carrito[index]['cantidad'] <= 0) {
      carrito.removeAt(index);
    }
    notifyListeners();
  }

  void eliminarDelCarrito(int index) {
    carrito.removeAt(index);
    notifyListeners();
  }

  void vaciarCarrito() {
    carrito.clear();
    notifyListeners();
  }

  // 8. Cerrar sesión (elimina el JWT y datos de usuario)
  void cerrarSesion() {
    token = null;
    usuarioActual = null;
    carrito.clear();
    notifyListeners();
  }
}