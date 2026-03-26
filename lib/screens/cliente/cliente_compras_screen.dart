import 'package:flutter/material.dart';
import '../../services/venta_service.dart';
import '../../models/venta.dart';

class ClienteComprasScreen extends StatefulWidget {
  const ClienteComprasScreen({super.key});

  @override
  State<ClienteComprasScreen> createState() => _ClienteComprasScreenState();
}

class _ClienteComprasScreenState extends State<ClienteComprasScreen> {

  late Future<List<Venta>> _futureVentas;

  @override
  void initState() {
    super.initState();
    _futureVentas = VentaService.obtenerVentas();
  }

  Future<void> _recargar() async {
    setState(() {
      _futureVentas = VentaService.obtenerVentas();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis compras'),
        backgroundColor: const Color(0xFF1F4A7C),
        foregroundColor: Colors.white,
      ),

      body: RefreshIndicator(
        onRefresh: _recargar,

        child: FutureBuilder<List<Venta>>(

          future: _futureVentas,

          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }

            final ventas = snapshot.data ?? [];

            if (ventas.isEmpty) {
              return const Center(
                child: Text("Aún no tienes compras"),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: ventas.length,

              itemBuilder: (context, index) {

                final v = ventas[index];

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),

                  child: Padding(
                    padding: const EdgeInsets.all(14),

                    child: Row(
                      children: [

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.shopping_bag,
                            color: Color(0xFF1F4A7C),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                "Compra #${v.id}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text("Fecha: ${v.fecha}"),

                              const SizedBox(height: 4),

                              Text(
                                "Total: \$${v.total.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      ],
                    ),
                  ),
                );

              },

            );

          },

        ),
      ),
    );
  }
}
