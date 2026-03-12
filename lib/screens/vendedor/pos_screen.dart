import 'package:flutter/material.dart';
import '../../models/producto.dart';
import '../../services/producto_service.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  late Future<List<Producto>> _futureProductos;
  final TextEditingController _searchCtrl = TextEditingController();
  String _search = '';

  final List<_CartItem> _carrito = [];
  bool _procesandoVenta = false;

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

  void _recargarProductos() {
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

  void _agregarAlCarrito(Producto producto) {
    final index = _carrito.indexWhere((item) => item.producto.id == producto.id);

    setState(() {
      if (index >= 0) {
        if (_carrito[index].cantidad < producto.stock) {
          _carrito[index].cantidad++;
        }
      } else {
        if (producto.stock > 0) {
          _carrito.add(_CartItem(producto: producto, cantidad: 1));
        }
      }
    });
  }

  void _incrementarCantidad(_CartItem item) {
    setState(() {
      if (item.cantidad < item.producto.stock) {
        item.cantidad++;
      }
    });
  }

  void _disminuirCantidad(_CartItem item) {
    setState(() {
      if (item.cantidad > 1) {
        item.cantidad--;
      } else {
        _carrito.remove(item);
      }
    });
  }

  void _quitarDelCarrito(_CartItem item) {
    setState(() {
      _carrito.remove(item);
    });
  }

  double get _total {
    return _carrito.fold(
      0,
      (sum, item) => sum + (item.producto.precioVenta * item.cantidad),
    );
  }

  Future<void> _confirmarVenta() async {
    if (_carrito.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega productos al carrito')),
      );
      return;
    }

    setState(() => _procesandoVenta = true);

    try {
      // Descuenta stock producto por producto
      for (final item in _carrito) {
        await ProductoService.descontarStock(
          idProducto: item.producto.id,
          cantidad: item.cantidad,
        );
      }

      final totalVenta = _total;

      if (!mounted) return;

      setState(() {
        _carrito.clear();
        _procesandoVenta = false;
      });

      _recargarProductos();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Venta realizada correctamente. Total: \$${totalVenta.toStringAsFixed(2)}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _procesandoVenta = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo completar la venta: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _cobrar() async {
    if (_carrito.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega productos al carrito')),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar venta'),
        content: Text(
          'Se descontará el stock real de los productos.\n\n'
          'Total a cobrar: \$${_total.toStringAsFixed(2)}',
        ),
        actions: [
          TextButton(
            onPressed: _procesandoVenta ? null : () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _procesandoVenta
                ? null
                : () async {
                    Navigator.pop(context);
                    await _confirmarVenta();
                  },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esAncho = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Punto de Venta'),
      ),
      body: FutureBuilder<List<Producto>>(
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

          if (esAncho) {
            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildProductos(productos),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  flex: 2,
                  child: _buildCarrito(),
                ),
              ],
            );
          }

          return Column(
            children: [
              Expanded(child: _buildProductos(productos)),
              SizedBox(
                height: 340,
                child: _buildCarrito(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductos(List<Producto> productos) {
    return Padding(
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
            child: productos.isEmpty
                ? const Center(child: Text('No se encontraron productos'))
                : GridView.builder(
                    itemCount: productos.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 280,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.15,
                    ),
                    itemBuilder: (context, index) {
                      final producto = productos[index];
                      final sinStock = producto.stock <= 0;

                      return Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                producto.nombre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text('Código: ${producto.codigo}'),
                              Text('Categoría: ${producto.categoria}'),
                              Text('Marca: ${producto.marca}'),
                              const Spacer(),
                              Text(
                                '\$${producto.precioVenta.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F4A7C),
                                ),
                              ),
                              Text('Stock: ${producto.stock}'),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: sinStock || _procesandoVenta
                                      ? null
                                      : () => _agregarAlCarrito(producto),
                                  icon: const Icon(Icons.add_shopping_cart),
                                  label: Text(
                                    sinStock ? 'Sin stock' : 'Agregar',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarrito() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Carrito',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F4A7C),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _carrito.isEmpty
                ? const Center(
                    child: Text('No hay productos en el carrito'),
                  )
                : ListView.builder(
                    itemCount: _carrito.length,
                    itemBuilder: (context, index) {
                      final item = _carrito[index];
                      return Card(
                        child: ListTile(
                          title: Text(item.producto.nombre),
                          subtitle: Text(
                            'Cantidad: ${item.cantidad}\n'
                            'Subtotal: \$${(item.producto.precioVenta * item.cantidad).toStringAsFixed(2)}',
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: _procesandoVenta
                                    ? null
                                    : () => _incrementarCantidad(item),
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                              IconButton(
                                onPressed: _procesandoVenta
                                    ? null
                                    : () => _disminuirCantidad(item),
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                            ],
                          ),
                          leading: IconButton(
                            onPressed: _procesandoVenta
                                ? null
                                : () => _quitarDelCarrito(item),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${_total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F4A7C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _procesandoVenta ? null : _cobrar,
              icon: _procesandoVenta
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.point_of_sale),
              label: Text(_procesandoVenta ? 'Procesando...' : 'Cobrar'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItem {
  final Producto producto;
  int cantidad;

  _CartItem({
    required this.producto,
    required this.cantidad,
  });
}
