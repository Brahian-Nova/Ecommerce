import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ecommerce_provider.dart';

class DetalleScreen extends StatefulWidget {
  const DetalleScreen({super.key});

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  int cantidad = 1;
  bool agregado = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EcommerceProvider>(context);
    final producto = provider.productoSeleccionado;

    if (producto == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Detalle')),
        body: Center(child: Text('No se seleccionó ningún producto')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'DETALLE DEL PRODUCTO',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Colors.blueGrey.shade700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueGrey.shade900,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen dentro de una tarjeta gris clara redondeada
              Container(
                height: 260,
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.network(
                  producto['imagen'],
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 18),

              // Etiqueta de categoría (amarilla como la marca)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  producto['categoria'],
                  style: TextStyle(
                    color: Colors.blueGrey.shade900,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),

              Text(
                producto['nombre'],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade900,
                ),
              ),
              SizedBox(height: 10),

              Text(
                '\$ ${producto['precio']}',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade900,
                ),
              ),
              SizedBox(height: 22),

              Text(
                'DESCRIPCIÓN',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: Colors.blueGrey.shade800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                producto['descripcion'],
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 24),

              // Selector de cantidad (estilo contador visto en clase)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      if (cantidad > 1) {
                        setState(() {
                          cantidad--;
                        });
                      }
                    },
                    child: Text(
                      '-',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueGrey.shade900,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '$cantidad',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade900,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        cantidad++;
                      });
                    },
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueGrey.shade900,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              if (agregado)
                Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Center(
                    child: Text(
                      '¡Producto agregado al carrito!',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    provider.agregarAlCarrito(producto, cantidad);
                    setState(() {
                      agregado = true;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Agregar al carrito',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade900,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Volver a la lista',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
