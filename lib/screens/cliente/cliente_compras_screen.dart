import 'package:flutter/material.dart';

class ClienteComprasScreen extends StatelessWidget {
  const ClienteComprasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final compras = [
      {
        'folio': 'VTA-001',
        'fecha': '11/03/2026',
        'total': 540.00,
        'estado': 'Entregada',
      },
      {
        'folio': 'VTA-002',
        'fecha': '09/03/2026',
        'total': 1280.50,
        'estado': 'Entregada',
      },
      {
        'folio': 'VTA-003',
        'fecha': '05/03/2026',
        'total': 310.00,
        'estado': 'En proceso',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis compras'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: compras.isEmpty
            ? const Center(
                child: Text('Aún no tienes compras registradas'),
              )
            : ListView.builder(
                itemCount: compras.length,
                itemBuilder: (context, index) {
                  final compra = compras[index];
                  final estado = compra['estado'] as String;
                  final color = estado == 'Entregada'
                      ? Colors.green
                      : Colors.orange;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color.withOpacity(0.15),
                        child: Icon(
                          Icons.receipt_long,
                          color: color,
                        ),
                      ),
                      title: Text(
                        'Folio: ${compra['folio']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Fecha: ${compra['fecha']}\n'
                        'Total: \$${(compra['total'] as double).toStringAsFixed(2)}\n'
                        'Estado: $estado',
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
