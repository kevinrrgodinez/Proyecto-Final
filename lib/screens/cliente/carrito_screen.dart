import 'package:flutter/material.dart';

import '../../services/carrito_service.dart';
import '../../services/venta_service.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  double calcularTotal(List<CarritoItem> carrito) {
    return carrito.fold(0, (total, item) => total + item.subtotal);
  }

  Future<void> comprarTodo(List<CarritoItem> carrito) async {
    try {
      await VentaService.registrarVenta(
        vendedor: 'Cliente App',
        cliente: 'Cliente mostrador',
        metodoPago: 'Efectivo',
        items: carrito
            .map(
              (item) => VentaItemPayload(
                idProducto: item.producto.id,
                cantidad: item.cantidad,
              ),
            )
            .toList(),
      );

      CarritoService.limpiarCarrito();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Compra realizada correctamente'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al comprar: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final carrito = CarritoService.obtenerCarrito();
    final total = calcularTotal(carrito);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              setState(() {
                CarritoService.limpiarCarrito();
              });
            },
          ),
        ],
      ),
      body: carrito.isEmpty
          ? const Center(child: Text('Carrito vacío'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: carrito.length,
                    itemBuilder: (context, index) {
                      final item = carrito[index];
                      final p = item.producto;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.nombre,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Precio: \$${p.precioVenta.toStringAsFixed(2)}',
                                    ),
                                    Text(
                                      'Subtotal: \$${item.subtotal.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      setState(() {
                                        CarritoService.disminuirCantidad(p);
                                      });
                                    },
                                  ),
                                  Text(
                                    '${item.cantidad}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      setState(() {
                                        CarritoService.aumentarCantidad(p);
                                      });
                                    },
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    CarritoService.eliminarProducto(p);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Total: \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            comprarTodo(carrito);
                          },
                          child: const Text('Comprar todo'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}