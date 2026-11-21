import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ecommerce_provider.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String mensaje = '';
  bool esError = false;
  bool cargando = false;

  // Texto que aparece en la ventanita superior al tocar las opciones del perfil
  String avisoSuperior = '';

  @override
  void initState() {
    super.initState();
    final usuario = Provider.of<EcommerceProvider>(context, listen: false).usuarioActual;
    if (usuario != null) {
      nombreController.text = usuario['nombre'];
      apellidosController.text = usuario['apellidos'];
      usernameController.text = usuario['username'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EcommerceProvider>(context);
    final usuario = provider.usuarioActual;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'Mi Perfil',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.blueGrey.shade900,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // 1. CABECERA AMARILLA DE PERFIL (foto, punto activo, nombre y puntos)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 16, bottom: 26, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: ClipOval(
                                child: SizedBox(
                                  width: 86,
                                  height: 86,
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            // Indicador verde de usuario activo
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  border: Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          usuario != null
                              ? '${usuario['nombre']} ${usuario['apellidos']}'
                              : 'Usuario',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade900,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Nivel Oro • 1.450 Puntos CMR / Meli',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blueGrey.shade800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          usuario != null
                              ? 'Activo • @${usuario['username']} • ${usuario['correo']}'
                              : 'Activo',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // 2. TARJETA "MI ACTIVIDAD" (Mis compras, Cupones, Favoritos)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MI ACTIVIDAD',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  color: Colors.blueGrey.shade900,
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/carrito');
                                    },
                                    child: Column(
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            width: 52,
                                            height: 52,
                                            color: Colors.blue.shade50,
                                            child: Icon(
                                              Icons.inventory_2_outlined,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Mis compras',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.blueGrey.shade900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        avisoSuperior =
                                            'Tienes un cupón de \$10.000 por compras superiores a \$100.000';
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            width: 52,
                                            height: 52,
                                            color: Colors.orange.shade50,
                                            child: Icon(
                                              Icons.confirmation_number_outlined,
                                              color: Colors.orange.shade800,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Cupones',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.blueGrey.shade900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        avisoSuperior =
                                            'Favoritos: Audífonos Bluetooth Pro, Chaqueta Impermeable';
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            width: 52,
                                            height: 52,
                                            color: Colors.red.shade50,
                                            child: Icon(
                                              Icons.favorite_border,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Favoritos',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.blueGrey.shade900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),

                        // 3. TARJETA DE OPCIONES (Direcciones, Pagos, Ayuda, Cerrar sesión)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    avisoSuperior =
                                        'Dirección de entrega: Calle 16 A # 45-20, Bogotá D.C.';
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on_outlined, color: Colors.grey),
                                      SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          'Direcciones de entrega',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blueGrey.shade900,
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.chevron_right, color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ),
                              Container(height: 1, color: Colors.grey.shade100),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    avisoSuperior =
                                        'Medios de pago: Tarjeta CMR, PSE, Tarjetas y Efecty';
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    children: [
                                      Icon(Icons.credit_card, color: Colors.grey),
                                      SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          'Medios de pago',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blueGrey.shade900,
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.chevron_right, color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ),
                              Container(height: 1, color: Colors.grey.shade100),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    avisoSuperior =
                                        'Ayuda & PQR: Línea 01 8000 123 456 • soporte@tiendaexpress.co';
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    children: [
                                      Icon(Icons.headset_mic_outlined, color: Colors.grey),
                                      SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          'Ayuda & PQR',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blueGrey.shade900,
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.chevron_right, color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ),
                              Container(height: 1, color: Colors.grey.shade100),
                              GestureDetector(
                                onTap: () {
                                  provider.cerrarSesion();
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/login',
                                    (route) => false,
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    children: [
                                      Icon(Icons.logout, color: Colors.red),
                                      SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          'Cerrar sesión',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.chevron_right, color: Colors.red),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),

                        // 4. EDITAR DATOS DEL PERFIL (lógica conectada al backend PUT /perfil)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'EDITAR MIS DATOS',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  color: Colors.blueGrey.shade900,
                                ),
                              ),
                              SizedBox(height: 14),
                              TextField(
                                controller: nombreController,
                                decoration: InputDecoration(
                                  labelText: 'Nombre',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              TextField(
                                controller: apellidosController,
                                decoration: InputDecoration(
                                  labelText: 'Apellidos',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              TextField(
                                controller: usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Nueva contraseña (dejar vacío para no cambiar)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              if (mensaje != '')
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12),
                                  child: Text(
                                    mensaje,
                                    style: TextStyle(
                                      color: esError ? Colors.red : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              cargando
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.blueGrey.shade900,
                                      ),
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () async {
                                          String nom = nombreController.text.trim();
                                          String ape = apellidosController.text.trim();
                                          String user = usernameController.text.trim();
                                          String pass = passwordController.text.trim();

                                          if (nom == '' || ape == '' || user == '') {
                                            setState(() {
                                              esError = true;
                                              mensaje =
                                                  'Nombre, apellidos y username son obligatorios';
                                            });
                                            return;
                                          }

                                          if (pass != '' && pass.length < 8) {
                                            setState(() {
                                              esError = true;
                                              mensaje =
                                                  'La nueva contraseña debe tener mínimo 8 caracteres';
                                            });
                                            return;
                                          }

                                          setState(() {
                                            cargando = true;
                                            mensaje = '';
                                          });

                                          String? res = await provider.actualizarPerfil(
                                            nom,
                                            ape,
                                            user,
                                            pass,
                                          );

                                          setState(() {
                                            cargando = false;
                                            if (res == null) {
                                              esError = false;
                                              mensaje = 'Cambios guardados correctamente';
                                              passwordController.clear();
                                            } else {
                                              esError = true;
                                              mensaje = res;
                                            }
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 12),
                                          child: Text(
                                            'Guardar cambios',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueGrey.shade900,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // VENTANITA / MENSAJE FLOTANTE EN LA PARTE SUPERIOR
            if (avisoSuperior != '')
              Positioned(
                top: 10,
                left: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      avisoSuperior = '';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade900,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.yellow,
                          size: 22,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            avisoSuperior,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.close, color: Colors.white70, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueGrey.shade900,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          } else if (index == 1) {
            Navigator.pushNamed(context, '/carrito');
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Carrito (${provider.carrito.length})',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Mi Perfil',
          ),
        ],
      ),
    );
  }
}
