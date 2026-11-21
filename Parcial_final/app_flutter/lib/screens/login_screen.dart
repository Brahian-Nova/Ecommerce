import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ecommerce_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController correoRecuperarController = TextEditingController();
  final TextEditingController nuevaPassController = TextEditingController();

  bool ocultarPassword = true;
  bool modoRecuperar = false;
  bool cargando = false;

  String errorUsuario = '';
  String errorPassword = '';
  String mensajeGeneral = '';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EcommerceProvider>(context, listen: false);

    return Scaffold(
      // Fondo blanco y AppBar sin sombra para un look limpio
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          modoRecuperar ? 'Recuperar Contraseña' : 'Iniciar Sesión',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueGrey.shade900,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 80,
                  color: Colors.yellow.shade700,
                ),
                SizedBox(height: 10),
                Text(
                  'TiendaExpress',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.blueGrey.shade900,
                  ),
                ),
                SizedBox(height: 36),

                // --- VISTA NORMAL DE LOGIN ---
                if (!modoRecuperar) ...[
                  TextField(
                    controller: usuarioController,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico o username',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                    ),
                  ),
                  if (errorUsuario != '')
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Text(errorUsuario, style: TextStyle(color: Colors.red, fontSize: 12)),
                        ],
                      ),
                    ),
                  SizedBox(height: 16),

                  TextField(
                    controller: passwordController,
                    obscureText: ocultarPassword,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                      suffixIcon: TextButton(
                        onPressed: () {
                          setState(() {
                            ocultarPassword = !ocultarPassword;
                          });
                        },
                        child: Icon(
                          ocultarPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  if (errorPassword != '')
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Text(errorPassword, style: TextStyle(color: Colors.red, fontSize: 12)),
                        ],
                      ),
                    ),
                  SizedBox(height: 10),

                  if (mensajeGeneral != '')
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        mensajeGeneral,
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),

                  SizedBox(height: 10),
                  cargando
                      ? CircularProgressIndicator(color: Colors.blueGrey.shade900)
                      : SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () async {
                              setState(() {
                                errorUsuario = '';
                                errorPassword = '';
                                mensajeGeneral = '';
                              });

                              String user = usuarioController.text.trim();
                              String pass = passwordController.text.trim();
                              bool valido = true;

                              if (user == '') {
                                errorUsuario = 'El campo no puede estar vacío';
                                valido = false;
                              } else if (user.contains('@') && !user.contains('.')) {
                                errorUsuario = 'Formato de email no válido';
                                valido = false;
                              }

                              if (pass.length < 6) {
                                errorPassword = 'Mínimo 6 caracteres en contraseña';
                                valido = false;
                              }

                              setState(() {});

                              if (valido) {
                                setState(() {
                                  cargando = true;
                                });
                                String? errorApi = await provider.login(user, pass);
                                setState(() {
                                  cargando = false;
                                });

                                if (errorApi == null) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/home',
                                    (route) => false,
                                  );
                                } else {
                                  setState(() {
                                    mensajeGeneral = errorApi;
                                  });
                                }
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                'Ingresar a la tienda  →',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey.shade900,
                                ),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: 12),

                  TextButton(
                    onPressed: () {
                      setState(() {
                        modoRecuperar = true;
                        mensajeGeneral = '';
                      });
                    },
                    child: Text(
                      '¿La olvidaste?',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/registro');
                    },
                    child: Text(
                      '¿No tienes una cuenta aún? Crea tu cuenta aquí',
                      style: TextStyle(
                        color: Colors.blueGrey.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],

                // --- VISTA DE RECUPERACIÓN DE CONTRASEÑA ---
                if (modoRecuperar) ...[
                  Text(
                    'Ingresa tu correo registrado y tu nueva contraseña:',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: correoRecuperarController,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico registrado',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: nuevaPassController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Nueva contraseña (mín. 6 caracteres)',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  if (mensajeGeneral != '')
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        mensajeGeneral,
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        String correo = correoRecuperarController.text.trim();
                        String nueva = nuevaPassController.text.trim();

                        if (correo == '' || !correo.contains('@') || !correo.contains('.')) {
                          setState(() {
                            mensajeGeneral = 'Ingresa un correo válido';
                          });
                          return;
                        }
                        if (nueva.length < 6) {
                          setState(() {
                            mensajeGeneral = 'La nueva contraseña debe tener mínimo 6 caracteres';
                          });
                          return;
                        }

                        String? res = await provider.recuperarPassword(correo, nueva);
                        setState(() {
                          if (res == null) {
                            mensajeGeneral = 'Contraseña actualizada. Ya puedes iniciar sesión.';
                            modoRecuperar = false;
                          } else {
                            mensajeGeneral = res;
                          }
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          'Restablecer contraseña',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade900,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        modoRecuperar = false;
                        mensajeGeneral = '';
                      });
                    },
                    child: Text(
                      'Volver al Login',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
