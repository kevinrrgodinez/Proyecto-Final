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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis compras'),
      ),

      body: FutureBuilder<List<Venta>>(

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
            itemCount: ventas.length,

            itemBuilder: (context, index) {

              final v = ventas[index];

              return Card(
                margin: const EdgeInsets.all(12),

                child: ListTile(

                  leading: const Icon(Icons.receipt_long),

                  title: Text(
                    "Compra #${v.id}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  subtitle: Text(
                    "Fecha: ${v.fecha}\nTotal: \$${v.total.toStringAsFixed(2)}"
                  ),

                ),
              );

            },

          );

        },

      ),

    );
  }
}