import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ecommerce_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController buscadorController = TextEditingController();
  String textoBusqueda = '';
  String categoriaSeleccionada = 'Todos';
  int bannerActual = 0;

  final List<String> banners = [
    'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800',
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
    'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800',
  ];

  final List<String> categorias = [
    'Todos',
    'Electrónica',
    'Ropa',
    'Hogar',
    'Calzado',
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<EcommerceProvider>(context, listen: false).getProductos();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EcommerceProvider>(context);
    final usuario = provider.usuarioActual;

    // Filtrar productos por texto del buscador y por categoría seleccionada
    List<dynamic> listaFiltrada = [];
    if (provider.productos != null) {
      for (int i = 0; i < provider.productos!.length; i++) {
        var prod = provider.productos![i];
        String nombre = prod['nombre'].toString().toLowerCase();
        String cat = prod['categoria'].toString();

        bool coincideTexto = nombre.contains(textoBusqueda.toLowerCase());
        bool coincideCategoria =
            (categoriaSeleccionada == 'Todos' || cat == categoriaSeleccionada);

        if (coincideTexto && coincideCategoria) {
          listaFiltrada.add(prod);
        }
      }
    }

    return Scaffold(
      // Fondo gris claro para que resalten las tarjetas blancas
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'TiendaExpress',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.blueGrey.shade900,
        elevation: 0,
      ),

      // --- DRAWER LATERAL ---
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Colors.blueGrey.shade900,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Container(
                        width: 65,
                        height: 65,
                        color: Colors.yellow,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.blueGrey.shade900,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      usuario != null
                          ? '${usuario['nombre']} ${usuario['apellidos']}'
                          : 'Usuario Invitado',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      usuario != null ? usuario['correo'] : '',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(Icons.home_outlined, color: Colors.blueGrey.shade900),
                  SizedBox(width: 10),
                  Text(
                    'Inicio',
                    style: TextStyle(color: Colors.blueGrey.shade900),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/carrito');
              },
              child: Row(
                children: [
                  Icon(Icons.shopping_bag_outlined,
                      color: Colors.blueGrey.shade900),
                  SizedBox(width: 10),
                  Text(
                    'Mis pedidos / Carrito',
                    style: TextStyle(color: Colors.blueGrey.shade900),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/perfil');
              },
              child: Row(
                children: [
                  Icon(Icons.person_outline, color: Colors.blueGrey.shade900),
                  SizedBox(width: 10),
                  Text(
                    'Perfil',
                    style: TextStyle(color: Colors.blueGrey.shade900),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    provider.cerrarSesion();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  },
                  child: Text(
                    'Cerrar sesión',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // --- CONTENIDO PRINCIPAL ---
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. BUSCADOR EN TIEMPO REAL (blanco y redondeado)
              TextField(
                controller: buscadorController,
                onChanged: (valor) {
                  setState(() {
                    textoBusqueda = valor;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Buscar en TiendaExpress...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // 2. BANNER PROMOCIONAL CON PUNTOS INDICADORES
              Stack(
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade900,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.network(
                      banners[bannerActual],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'OFERTAS ESPECIALES',
                        style: TextStyle(
                          color: Colors.blueGrey.shade900,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < banners.length; i++)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            bannerActual = i;
                          });
                        },
                        child: Container(
                          // El punto activo es más ancho (efecto "píldora")
                          width: bannerActual == i ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: bannerActual == i
                                ? Colors.blueGrey.shade900
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16),

              // 3. FILTRO POR CATEGORÍAS (HORIZONTAL)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < categorias.length; i++)
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              categoriaSeleccionada = categorias[i];
                            });
                          },
                          child: Text(
                            categorias[i],
                            style: TextStyle(
                              fontWeight: categoriaSeleccionada == categorias[i]
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: categoriaSeleccionada == categorias[i]
                                  ? Colors.blueGrey.shade900
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // 4. LISTADO DE PRODUCTOS (2 COLUMNAS)
              if (provider.productos == null)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                )
              else if (listaFiltrada.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      'No se encontraron productos',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    for (int i = 0; i < listaFiltrada.length; i += 2)
                      Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tarjeta izquierda
                            Expanded(
                              child: _construirTarjetaProducto(
                                context,
                                provider,
                                listaFiltrada[i],
                              ),
                            ),
                            SizedBox(width: 12),
                            // Tarjeta derecha (si existe elemento par)
                            if (i + 1 < listaFiltrada.length)
                              Expanded(
                                child: _construirTarjetaProducto(
                                  context,
                                  provider,
                                  listaFiltrada[i + 1],
                                ),
                              )
                            else
                              Expanded(child: SizedBox()),
                          ],
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),

      // --- BARRA DE NAVEGACIÓN INFERIOR ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueGrey.shade900,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/carrito');
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

  Widget _construirTarjetaProducto(
    BuildContext context,
    EcommerceProvider provider,
    Map<String, dynamic> producto,
  ) {
    return GestureDetector(
      onTap: () {
        provider.seleccionarProducto(producto);
        Navigator.pushNamed(context, '/detalle');
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 130,
              width: double.infinity,
              child: Image.network(
                producto['imagen'],
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              producto['nombre'],
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.blueGrey.shade900,
              ),
            ),
            SizedBox(height: 6),
            Text(
              '\$${producto['precio']}',
              style: TextStyle(
                color: Colors.blueGrey.shade900,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
