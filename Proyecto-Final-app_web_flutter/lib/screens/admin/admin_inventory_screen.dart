import 'package:flutter/material.dart';
import '../../models/producto.dart';
import '../../services/producto_service.dart';

class AdminInventoryScreen extends StatefulWidget {
  const AdminInventoryScreen({super.key});

  @override
  State<AdminInventoryScreen> createState() => _AdminInventoryScreenState();
}

class _AdminInventoryScreenState extends State<AdminInventoryScreen> {
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
        title: const Text('Inventario'),
        actions: [
          IconButton(
            onPressed: _recargar,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<Producto>>(
          future: _futureProductos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error al cargar inventario:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final productos = _filtrar(snapshot.data ?? []);
            final total = productos.length;
            final bajoStock = productos.where((p) => p.stock <= p.stockMinimo).length;

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        titulo: 'Total productos',
                        valor: total.toString(),
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoCard(
                        titulo: 'Stock bajo',
                        valor: bajoStock.toString(),
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Buscar en inventario',
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
                  child: productos.isEmpty
                      ? const Center(child: Text('No se encontraron productos'))
                      : ListView.builder(
                          itemCount: productos.length,
                          itemBuilder: (context, index) {
                            final p = productos[index];
                            final stockBajo = p.stock <= p.stockMinimo;

                            return Card(
                              color: stockBajo ? Colors.red.shade50 : null,
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: stockBajo
                                      ? Colors.red.shade100
                                      : Colors.blue.shade100,
                                  child: Icon(
                                    stockBajo
                                        ? Icons.warning_amber_rounded
                                        : Icons.inventory_2_outlined,
                                    color: stockBajo ? Colors.red : Colors.blue,
                                  ),
                                ),
                                title: Text(
                                  p.nombre,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Código: ${p.codigo}\n'
                                  'Stock: ${p.stock}\n'
                                  'Stock mínimo: ${p.stockMinimo}\n'
                                  'Unidad: ${p.unidadMedida}\n'
                                  'Categoría: ${p.categoria}',
                                ),
                                trailing: Text(
                                  stockBajo ? 'Bajo' : 'OK',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: stockBajo ? Colors.red : Colors.green,
                                  ),
                                ),
                                isThreeLine: true,
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final Color color;

  const _InfoCard({
    required this.titulo,
    required this.valor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Column(
          children: [
            Text(
              titulo,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              valor,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
