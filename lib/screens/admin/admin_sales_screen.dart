import 'package:flutter/material.dart';

class AdminSalesScreen extends StatelessWidget {
  const AdminSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ventas = [
      {
        'folio': 'VTA-1001',
        'cliente': 'Ana López',
        'vendedor': 'Luis Hernández',
        'fecha': '11/03/2026',
        'total': 890.00,
      },
      {
        'folio': 'VTA-1002',
        'cliente': 'Carlos Pérez',
        'vendedor': 'Luis Hernández',
        'fecha': '10/03/2026',
        'total': 430.50,
      },
      {
        'folio': 'VTA-1003',
        'cliente': 'María Torres',
        'vendedor': 'Sofía Cruz',
        'fecha': '09/03/2026',
        'total': 1540.00,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de ventas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ventas.isEmpty
            ? const Center(
                child: Text('No hay ventas registradas'),
              )
            : ListView.builder(
                itemCount: ventas.length,
                itemBuilder: (context, index) {
                  final venta = ventas[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            const Color(0xFF1F4A7C).withOpacity(0.1),
                        child: const Icon(
                          Icons.receipt_long_outlined,
                          color: Color(0xFF1F4A7C),
                        ),
                      ),
                      title: Text(
                        'Folio: ${venta['folio']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Cliente: ${venta['cliente']}\n'
                        'Vendedor: ${venta['vendedor']}\n'
                        'Fecha: ${venta['fecha']}\n'
                        'Total: \$${(venta['total'] as double).toStringAsFixed(2)}',
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
