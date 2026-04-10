import 'package:flutter/material.dart';

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clientes = [
      {
        'nombre': 'Ana López',
        'correo': 'ana@email.com',
        'telefono': '7711234567',
      },
      {
        'nombre': 'Carlos Pérez',
        'correo': 'carlos@email.com',
        'telefono': '7719876543',
      },
      {
        'nombre': 'María Torres',
        'correo': 'maria@email.com',
        'telefono': '7715557788',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registro de clientes próximamente'),
            ),
          );
        },
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Agregar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: clientes.isEmpty
            ? const Center(
                child: Text('No hay clientes registrados'),
              )
            : ListView.builder(
                itemCount: clientes.length,
                itemBuilder: (context, index) {
                  final cliente = clientes[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            const Color(0xFF1F4A7C).withOpacity(0.1),
                        child: const Icon(
                          Icons.person_outline,
                          color: Color(0xFF1F4A7C),
                        ),
                      ),
                      title: Text(
                        cliente['nombre'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Correo: ${cliente['correo']}\n'
                        'Teléfono: ${cliente['telefono']}',
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
