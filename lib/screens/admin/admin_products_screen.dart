import 'package:flutter/material.dart';
import '../../models/producto.dart';
import '../../services/producto_service.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
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

  void _recargar() {
    setState(() {
      _futureProductos = ProductoService.obtenerProductos();
    });
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
        title: const Text('Productos'),
        actions: [
          IconButton(
            onPressed: _recargar,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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
                        'Error al cargar productos:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final productos = _filtrar(snapshot.data ?? []);

                  if (productos.isEmpty) {
                    return const Center(
                      child: Text('No se encontraron productos'),
                    );
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final esPantallaGrande = constraints.maxWidth > 850;

                      if (esPantallaGrande) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Código')),
                              DataColumn(label: Text('Nombre')),
                              DataColumn(label: Text('Categoría')),
                              DataColumn(label: Text('Marca')),
                              DataColumn(label: Text('Precio')),
                              DataColumn(label: Text('Stock')),
                            ],
                            rows: productos.map((p) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(p.codigo)),
                                  DataCell(Text(p.nombre)),
                                  DataCell(Text(p.categoria)),
                                  DataCell(Text(p.marca)),
                                  DataCell(Text('\$${p.precioVenta.toStringAsFixed(2)}')),
                                  DataCell(Text(p.stock.toString())),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: productos.length,
                        itemBuilder: (context, index) {
                          final p = productos[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(
                                p.nombre,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Código: ${p.codigo}\n'
                                'Categoría: ${p.categoria}\n'
                                'Marca: ${p.marca}\n'
                                'Precio: \$${p.precioVenta.toStringAsFixed(2)}\n'
                                'Stock: ${p.stock}',
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
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
