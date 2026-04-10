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

  void _mostrarFormulario({Producto? producto}) {
    final codigoCtrl = TextEditingController(text: producto?.codigo ?? '');
    final nombreCtrl = TextEditingController(text: producto?.nombre ?? '');
    final precioCtrl = TextEditingController(
        text: producto != null ? producto.precioVenta.toString() : '');
    final stockCtrl = TextEditingController(
        text: producto != null ? producto.stock.toString() : '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(producto == null ? 'Nuevo producto' : 'Editar producto'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: codigoCtrl,
                decoration: const InputDecoration(labelText: 'Código'),
              ),
              TextField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: precioCtrl,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stockCtrl,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final nuevoProducto = Producto(
                  id: producto?.id ?? '', // ✅ STRING
                  codigo: codigoCtrl.text,
                  nombre: nombreCtrl.text,
                  descripcion: producto?.descripcion ?? '',
                  precioVenta: double.parse(precioCtrl.text),
                  costo: producto?.costo ?? 0,
                  stock: int.parse(stockCtrl.text),
                  stockMinimo: producto?.stockMinimo ?? 0,
                  categoria: producto?.categoria ?? '',
                  marca: producto?.marca ?? '',
                  unidadMedida: producto?.unidadMedida ?? '',
                  activo: producto?.activo ?? true,
                );

                if (producto == null) {
                  await ProductoService.crearProducto(nuevoProducto);
                } else {
                  await ProductoService.actualizarProducto(
                    producto.id, // ✅ STRING
                    nuevoProducto,
                  );
                }

                Navigator.pop(context);
                _recargar();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _eliminarProducto(String id) async { // ✅ STRING
    final confirmar = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Eliminar producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await ProductoService.eliminarProducto(id); // ✅ STRING
        _recargar();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e')),
        );
      }
    }
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
          IconButton(
            onPressed: () => _mostrarFormulario(),
            icon: const Icon(Icons.add),
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
                              DataColumn(label: Text('Acciones')),
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
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.blue),
                                          onPressed: () => _mostrarFormulario(producto: p),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => _eliminarProducto(p.id), // ✅ STRING
                                        ),
                                      ],
                                    ),
                                  ),
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
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _mostrarFormulario(producto: p),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _eliminarProducto(p.id), // ✅
                                  ),
                                ],
                              ),
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