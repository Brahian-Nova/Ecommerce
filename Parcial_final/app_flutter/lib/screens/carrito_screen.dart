import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ecommerce_provider.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  bool procesandoPago = false;
  bool compraRealizada = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EcommerceProvider>(context);
    final carrito = provider.carrito;

    // Cálculos del resumen del pedido
    double subtotal = 0;
    for (int i = 0; i < carrito.length; i++) {
      subtotal += carrito[i]['precio'] * carrito[i]['cantidad'];
    }
    double iva = subtotal * 0.19;
    double envio = carrito.isEmpty ? 0 : 10000;
    double total = subtotal + iva + envio;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'Carrito de compras',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueGrey.shade900,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Factura y número de guía generados al completar la compra
              if (compraRealizada && provider.pedidos.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 46),
                            SizedBox(height: 8),
                            Text(
                              '¡Compra realizada con éxito!',
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Comprobante de compra - TiendaExpress',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Código de factura:',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                                Text(
                                  provider.pedidos[0]['factura'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey.shade900,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Número de guía:',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                                Text(
                                  provider.pedidos[0]['guia'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Productos comprados:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade900,
                        ),
                      ),
                      SizedBox(height: 6),
                      for (int j = 0; j < provider.pedidos[0]['items'].length; j++)
                        Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${provider.pedidos[0]['items'][j]['cantidad']}x ${provider.pedidos[0]['items'][j]['nombre']}',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              Text(
                                '\$${(provider.pedidos[0]['items'][j]['precio'] * provider.pedidos[0]['items'][j]['cantidad']).toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total pagado:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey.shade900,
                            ),
                          ),
                          Text(
                            '\$${provider.pedidos[0]['total'].toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              // Carrito vacío
              if (carrito.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 70, color: Colors.grey.shade400),
                        SizedBox(height: 12),
                        Text(
                          'Tu carrito está vacío',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade900,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Explora el catálogo y agrega productos.',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        SizedBox(height: 20),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (route) => false,
                            );
                          },
                          child: Text(
                            'Ir al catálogo',
                            style: TextStyle(
                              color: Colors.blueGrey.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                // Listado de ítems en el carrito (tarjetas blancas)
                for (int i = 0; i < carrito.length; i++)
                  Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: Image.network(
                            carrito[i]['imagen'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                carrito[i]['nombre'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.blueGrey.shade900,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '\$${carrito[i]['precio']} c/u',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blueGrey.shade900,
                                ),
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      provider.cambiarCantidadCarrito(i, -1);
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
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      '${carrito[i]['cantidad']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey.shade900,
                                      ),
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      provider.cambiarCantidadCarrito(i, 1);
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
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            provider.eliminarDelCarrito(i);
                          },
                          child: Icon(Icons.delete_outline, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 8),

                // Resumen del pedido (tarjeta blanca)
                Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RESUMEN DE COMPRA',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: Colors.blueGrey.shade900,
                        ),
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          Text(
                            '\$${subtotal.toStringAsFixed(0)}',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Impuestos (IVA 19%)',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          Text(
                            '\$${iva.toStringAsFixed(0)}',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Costo de envío',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          Text(
                            '\$${envio.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total a pagar:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey.shade900,
                            ),
                          ),
                          Text(
                            '\$${total.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey.shade900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Botón Proceder al pago con Loading
                procesandoPago
                    ? Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(
                              color: Colors.blueGrey.shade900,
                            ),
                            SizedBox(height: 8),
                            Text('Procesando compra...'),
                          ],
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              procesandoPago = true;
                            });
                            await Future.delayed(Duration(seconds: 2));
                            provider.registrarPedido(subtotal, iva, envio, total);
                            setState(() {
                              procesandoPago = false;
                              compraRealizada = true;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'PROCEDER AL PAGO',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey.shade900,
                              ),
                            ),
                          ),
                        ),
                      ),
              ],

              // Historial de pedidos realizados (visible desde "Mis pedidos / Carrito")
              if (provider.pedidos.isNotEmpty) ...[
                SizedBox(height: 24),
                Text(
                  'MIS PEDIDOS REALIZADOS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Colors.blueGrey.shade900,
                  ),
                ),
                SizedBox(height: 12),
                for (int p = 0; p < provider.pedidos.length; p++)
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Factura: ${provider.pedidos[p]['factura']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey.shade900,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Confirmado',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Guía de envío: ${provider.pedidos[p]['guia']}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        for (int j = 0; j < provider.pedidos[p]['items'].length; j++)
                          Padding(
                            padding: EdgeInsets.only(bottom: 2),
                            child: Text(
                              '• ${provider.pedidos[p]['items'][j]['cantidad']}x ${provider.pedidos[p]['items'][j]['nombre']}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$${provider.pedidos[p]['total'].toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey.shade900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueGrey.shade900,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          } else if (index == 2) {
            Navigator.pushNamed(context, '/perfil');
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
