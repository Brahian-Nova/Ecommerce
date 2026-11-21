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
      appBar: AppBar(
        title: Text('Mi Perfil'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Avatar circular con ClipOval
              ClipOval(
                child: Container(
                  width: 90,
                  height: 90,
                  color: Colors.blue,
                  child: Icon(Icons.person, size: 55, color: Colors.white),
                ),
              ),
              SizedBox(height: 12),

              Text(
                usuario != null
                    ? '${usuario['nombre']} ${usuario['apellidos']}'
                    : 'Usuario',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                usuario != null ? '@${usuario['username']}' : '',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                usuario != null ? usuario['correo'] : '',
                style: TextStyle(color: Colors.blue),
              ),
              SizedBox(height: 24),

              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),

              TextField(
                controller: apellidosController,
                decoration: InputDecoration(
                  labelText: 'Apellidos',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),

              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Nueva contraseña (dejar vacío para no cambiar)',
                  border: OutlineInputBorder(),
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
                  ? CircularProgressIndicator()
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
                              mensaje = 'Nombre, apellidos y username son obligatorios';
                            });
                            return;
                          }

                          if (pass != '' && pass.length < 8) {
                            setState(() {
                              esError = true;
                              mensaje = 'La nueva contraseña debe tener mínimo 8 caracteres';
                            });
                            return;
                          }

                          setState(() {
                            cargando = true;
                            mensaje = '';
                          });

                          String? res = await provider.actualizarPerfil(nom, ape, user, pass);

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
                        child: Text('Guardar cambios'),
                      ),
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          } else if (index == 1) {
            Navigator.pushNamed(context, '/carrito');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/perfil');
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito (${provider.carrito.length})',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
