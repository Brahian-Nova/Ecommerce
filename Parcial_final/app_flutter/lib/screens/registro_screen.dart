import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ecommerce_provider.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmarController = TextEditingController();

  String errorNombre = '';
  String errorApellidos = '';
  String errorUsername = '';
  String errorCorreo = '';
  String errorPassword = '';
  String errorConfirmar = '';
  String errorBackend = '';

  bool cargando = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EcommerceProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Cuenta'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              if (errorNombre != '')
                Row(children: [Text(errorNombre, style: TextStyle(color: Colors.red, fontSize: 12))]),
              SizedBox(height: 12),

              TextField(
                controller: apellidosController,
                decoration: InputDecoration(
                  labelText: 'Apellidos',
                  border: OutlineInputBorder(),
                ),
              ),
              if (errorApellidos != '')
                Row(children: [Text(errorApellidos, style: TextStyle(color: Colors.red, fontSize: 12))]),
              SizedBox(height: 12),

              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              if (errorUsername != '')
                Row(children: [Text(errorUsername, style: TextStyle(color: Colors.red, fontSize: 12))]),
              SizedBox(height: 12),

              TextField(
                controller: correoController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
              ),
              if (errorCorreo != '')
                Row(children: [Text(errorCorreo, style: TextStyle(color: Colors.red, fontSize: 12))]),
              SizedBox(height: 12),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña (mín. 8 caracteres)',
                  border: OutlineInputBorder(),
                ),
              ),
              if (errorPassword != '')
                Row(children: [Text(errorPassword, style: TextStyle(color: Colors.red, fontSize: 12))]),
              SizedBox(height: 12),

              TextField(
                controller: confirmarController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Verificar contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              if (errorConfirmar != '')
                Row(children: [Text(errorConfirmar, style: TextStyle(color: Colors.red, fontSize: 12))]),
              SizedBox(height: 16),

              if (errorBackend != '')
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(errorBackend, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),

              cargando
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          setState(() {
                            errorNombre = '';
                            errorApellidos = '';
                            errorUsername = '';
                            errorCorreo = '';
                            errorPassword = '';
                            errorConfirmar = '';
                            errorBackend = '';
                          });

                          String nom = nombreController.text.trim();
                          String ape = apellidosController.text.trim();
                          String user = usernameController.text.trim();
                          String mail = correoController.text.trim();
                          String pass = passwordController.text.trim();
                          String conf = confirmarController.text.trim();

                          bool valido = true;

                          if (nom == '') {
                            errorNombre = 'El nombre es obligatorio';
                            valido = false;
                          }
                          if (ape == '') {
                            errorApellidos = 'Los apellidos son obligatorios';
                            valido = false;
                          }
                          if (user == '') {
                            errorUsername = 'El username es obligatorio';
                            valido = false;
                          }
                          if (mail == '' || !mail.contains('@') || !mail.contains('.')) {
                            errorCorreo = 'Formato de email no válido';
                            valido = false;
                          }
                          if (pass.length < 8) {
                            errorPassword = 'La contraseña debe tener mínimo 8 caracteres';
                            valido = false;
                          }
                          if (conf != pass) {
                            errorConfirmar = 'Las contraseñas no coinciden';
                            valido = false;
                          }

                          setState(() {});

                          if (valido) {
                            setState(() {
                              cargando = true;
                            });
                            String? res = await provider.registrar(nom, ape, user, mail, pass);
                            setState(() {
                              cargando = false;
                            });

                            if (res == null) {
                              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                            } else {
                              setState(() {
                                errorBackend = res;
                              });
                            }
                          }
                        },
                        child: Text('Registrarse'),
                      ),
                    ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
                child: Text('Ya tengo cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}