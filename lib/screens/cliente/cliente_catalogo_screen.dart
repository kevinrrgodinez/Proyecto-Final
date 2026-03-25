import 'package:flutter/material.dart';
import '../../models/producto.dart';
import '../../core/routes/app_routes.dart';
import '../../services/carrito_service.dart';
import '../../services/producto_service.dart';

class ClienteCatalogoScreen extends StatefulWidget {
  const ClienteCatalogoScreen({super.key});

  @override
  State<ClienteCatalogoScreen> createState() => _ClienteCatalogoScreenState();
}

class _ClienteCatalogoScreenState extends State<ClienteCatalogoScreen> {
  late Future<List<Producto>> _futureProductos;
  final TextEditingController _searchCtrl = TextEditingController();
  String _search = '';

  @override
  void initState() {
    super.initState();
    _futureProductos = ProductoService.obtenerProductos();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Producto> _filtrar(List<Producto> productos) {
    if (_search.trim().isEmpty) return productos;

    final texto = _search.toLowerCase();
    return productos.where((p) {
      return p.nombre.toLowerCase().contains(texto) ||
          p.codigo.toLowerCase().contains(texto) ||
          p.categoria.toLowerCase().contains(texto) ||
          p.marca.toLowerCase().contains(texto);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F4A7C),
        title: const Text('Catálogo'),
        foregroundColor: Colors.white,

        // 🔴 SALIR
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          },
        ),

        // 🔵 ICONOS
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.carrito);
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.clienteCompras);
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.clientePerfil);
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // 🔍 BUSCADOR
            TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                labelText: 'Buscar producto',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _search = value;
                });
              },
            ),

            const SizedBox(height: 16),

            Expanded(
              child: FutureBuilder<List<Producto>>(
                future: _futureProductos,

                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final productos = _filtrar(snapshot.data ?? []);

                  if (productos.isEmpty) {
                    return const Center(
                      child: Text('No se encontraron productos'),
                    );
                  }

                  return GridView.builder(
                    itemCount: productos.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 280,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),

                    itemBuilder: (context, index) {

                      final p = productos[index];
                      final sinStock = p.stock <= 0;

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(14),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // ICONO
                              Container(
                                height: 110,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.inventory_2_outlined,
                                  size: 52,
                                  color: Color(0xFF1F4A7C),
                                ),
                              ),

                              const SizedBox(height: 12),

                              Text(
                                p.nombre,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 6),

                              Text('Categoría: ${p.categoria}'),
                              Text('Marca: ${p.marca}'),

                              const Spacer(),

                              Text(
                                '\$${p.precioVenta.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F4A7C),
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                sinStock ? 'Sin stock' : 'Disponible',
                                style: TextStyle(
                                  color: sinStock ? Colors.red : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // 🛒 BOTÓN
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: sinStock
                                      ? null
                                      : () {
                                          CarritoService.agregarProducto(p);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "${p.nombre} agregado al carrito"),
                                            ),
                                          );
                                        },
                                  child: const Text("Agregar al carrito"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}