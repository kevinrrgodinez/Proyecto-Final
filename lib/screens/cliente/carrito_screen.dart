import 'package:flutter/material.dart';
import '../../services/carrito_service.dart';
import '../../models/producto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {

  double calcularTotal(List<Producto> carrito) {
    return carrito.fold(0, (total, p) => total + p.precioVenta);
  }

  Future<void> comprarTodo(List<Producto> carrito) async {
    try {
      for (var p in carrito) {
        await http.post(
          Uri.parse('http://127.0.0.1:8000/comprar/${p.id}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"cantidad": 1}),
        );
      }
      
      CarritoService.limpiarCarrito();

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Compra realizada correctamente")),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al comprar")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final carrito = CarritoService.obtenerCarrito();
    final total = calcularTotal(carrito);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrito"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              setState(() {
                CarritoService.limpiarCarrito();
              });
            },
          )
        ],
      ),

      body: carrito.isEmpty
          ? const Center(child: Text("Carrito vacío"))
          : Column(
              children: [

                // 🛒 LISTA
                Expanded(
                  child: ListView.builder(
                    itemCount: carrito.length,
                    itemBuilder: (context, index) {
                      final p = carrito[index];

                      return ListTile(
                        title: Text(p.nombre),
                        subtitle: Text("\$${p.precioVenta.toStringAsFixed(2)}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              CarritoService.eliminarProducto(p);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),

                // 💰 TOTAL + BOTÓN
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Total: \$${total.toStringAsFixed(2)}",
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
                          child: const Text("Comprar todo"),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}