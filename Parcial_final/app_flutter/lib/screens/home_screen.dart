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
  // Guarda la cantidad seleccionada en cada tarjeta del catálogo (id -> cantidad)
  Map<String, dynamic> cantidades = {};

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
              // 1. BARRA DE DIRECCIÓN DE ENVÍO
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Colors.blueGrey.shade900,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Enviar a Bogotá D.C. - Cra 7 #72-10',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey.shade900,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: Colors.blueGrey.shade900,
                    ),
                  ],
                ),
              ),

              // 2. BUSCADOR EN TIEMPO REAL (blanco y redondeado)
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

              // 3. BANNER PUBLICITARIO CON PUNTOS INDICADORES
              Stack(
                children: [
                  Container(
                    height: 175,
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade900,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  bannerActual == 0
                                      ? 'OFERTA FLASH 40% OFF'
                                      : bannerActual == 1
                                          ? 'MODA TEMPORADA 30% OFF'
                                          : 'ENVÍO GRATIS HOY',
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade900,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                bannerActual == 0
                                    ? 'Especial Tecnología & Hogar'
                                    : bannerActual == 1
                                        ? 'Renueva tu Estilo'
                                        : 'Lo Mejor en Accesorios',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Con despacho gratis hoy mismo en compras seleccionadas.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Ver ofertas  >',
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade900,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 105,
                          height: 115,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.yellow, width: 2),
                          ),
                          child: Image.network(
                            banners[bannerActual],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
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

              // 4. FILTRO POR CATEGORÍAS (HORIZONTAL)
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
              SizedBox(height: 14),

              // 5. FRANJA PUBLICITARIA DE ENTREGA EXPRESS
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green.shade100),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.bolt, color: Colors.green, size: 20),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Entrega rápida en menos de 24h',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'EXPRESS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // TÍTULO DE SECCIÓN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RECOMENDADOS PARA TI',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                  Text(
                    '${listaFiltrada.length} productos',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

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
    String idProd = producto['id'].toString();
    int cant = cantidades[idProd] ?? 1;

    // Algunos productos muestran etiqueta de descuento y otros no (solo visual)
    int idNum = producto['id'];
    bool tieneDescuento = (idNum % 2 == 1);
    int porcentaje = idNum == 1 ? 23 : (idNum == 3 ? 14 : 20);
    double precioAnterior = producto['precio'] * (1 + porcentaje / 100);

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Al tocar imagen, nombre o precio se abre el detalle del producto
          GestureDetector(
            onTap: () {
              provider.seleccionarProducto(producto);
              Navigator.pushNamed(context, '/detalle');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 130,
                      width: double.infinity,
                      child: Image.network(
                        producto['imagen'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (tieneDescuento)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '-$porcentaje%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
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
                if (tieneDescuento)
                  Text(
                    '\$${precioAnterior.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                Text(
                  '\$${producto['precio']}',
                  style: TextStyle(
                    color: Colors.blueGrey.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                if (tieneDescuento)
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          size: 14,
                          color: Colors.green,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Envío Gratis',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // Selector de cantidad (- / cantidad / +) sin salir del catálogo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (cant > 1) {
                    setState(() {
                      cantidades[idProd] = cant - 1;
                    });
                  }
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '-',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade900,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                '$cant',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade900,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    cantidades[idProd] = cant + 1;
                  });
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '+',
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
          ),
          SizedBox(height: 8),

          // Botón para agregar al carrito con la cantidad escogida
          GestureDetector(
            onTap: () {
              provider.agregarAlCarrito(producto, cant);
              setState(() {
                cantidades[idProd] = 1;
              });
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Agregar',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
