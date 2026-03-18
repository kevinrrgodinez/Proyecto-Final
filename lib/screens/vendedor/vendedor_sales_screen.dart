import 'package:flutter/material.dart';

class VendedorSalesScreen extends StatelessWidget {
  const VendedorSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ventas = [
      {
        'folio': 'VTA-2001',
        'cliente': 'Ana López',
        'fecha': '11/03/2026',
        'total': 450.00,
        'metodo': 'Efectivo',
      },
      {
        'folio': 'VTA-2002',
        'cliente': 'Carlos Pérez',
        'fecha': '10/03/2026',
        'total': 980.50,
        'metodo': 'Tarjeta',
      },
      {
        'folio': 'VTA-2003',
        'cliente': 'María Torres',
        'fecha': '09/03/2026',
        'total': 220.00,
        'metodo': 'Efectivo',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis ventas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ventas.isEmpty
            ? const Center(
                child: Text('Aún no tienes ventas registradas'),
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
                          Icons.point_of_sale_outlined,
                          color: Color(0xFF1F4A7C),
                        ),
                      ),
                      title: Text(
                        'Folio: ${venta['folio']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Cliente: ${venta['cliente']}\n'
                        'Fecha: ${venta['fecha']}\n'
                        'Método: ${venta['metodo']}\n'
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
