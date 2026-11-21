import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/ecommerce_provider.dart';
import 'screens/login_screen.dart';
import 'screens/registro_screen.dart';
import 'screens/home_screen.dart';
import 'screens/detalle_screen.dart';
import 'screens/carrito_screen.dart';
import 'screens/perfil_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EcommerceProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App E-Commerce',
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/registro': (context) => const RegistroScreen(),
          '/home': (context) => const HomeScreen(),
          '/detalle': (context) => const DetalleScreen(),
          '/carrito': (context) => const CarritoScreen(),
          '/perfil': (context) => const PerfilScreen(),
        },
      ),
    );
  }
}