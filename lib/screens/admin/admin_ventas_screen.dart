import 'package:flutter/material.dart';
import '../../models/venta.dart';
import '../../services/venta_service.dart';

class AdminVentasScreen extends StatefulWidget {
  const AdminVentasScreen({super.key});

  @override
 State<AdminVentasScreen> createState() => _AdminVentasScreenState();
}

class _AdminVentasScreenState extends State<AdminVentasScreen> {

  late Future<List<Venta>> _futureVentas;

  @override
  void initState() {
    super.initState();
    _futureVentas = VentaService.obtenerVentas();
  }

  void _recargar() {
    setState(() {
      _futureVentas = VentaService.obtenerVentas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas'),
        actions: [
          IconButton(
            onPressed: _recargar,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<Venta>>(
          future: _futureVentas,
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final ventas = snapshot.data ?? [];

            if (ventas.isEmpty) {
              return const Center(
                child: Text('No hay ventas registradas'),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {

                final esPantallaGrande = constraints.maxWidth > 800;

                if (esPantallaGrande) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Cliente')),
                        DataColumn(label: Text('Total')),
                        DataColumn(label: Text('Fecha')),
                      ],
                      rows: ventas.map((v) {
                        return DataRow(
                          cells: [
                            DataCell(Text(v.id.toString())),
                            DataCell(Text(v.cliente ?? 'N/A')),
                            DataCell(Text('\$${v.total.toStringAsFixed(2)}')),
                            DataCell(Text(v.fecha ?? '')),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: ventas.length,
                  itemBuilder: (context, index) {
                    final v = ventas[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          'Venta #${v.id}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Cliente: ${v.cliente ?? 'N/A'}\n'
                          'Total: \$${v.total.toStringAsFixed(2)}\n'
                          'Fecha: ${v.fecha ?? ''}',
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
    );
  }
}