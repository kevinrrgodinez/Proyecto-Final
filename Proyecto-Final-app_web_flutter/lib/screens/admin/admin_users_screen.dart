import 'package:flutter/material.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarios = [
      {
        'nombre': 'María González',
        'usuario': 'maria.admin',
        'rol': 'Administrador',
        'activo': true,
      },
      {
        'nombre': 'Luis Hernández',
        'usuario': 'luis.vendedor',
        'rol': 'Vendedor',
        'activo': true,
      },
      {
        'nombre': 'Ana López',
        'usuario': 'ana.cliente',
        'rol': 'Cliente',
        'activo': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Formulario de usuario próximamente')),
          );
        },
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Agregar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final esAncho = constraints.maxWidth > 800;

            if (esAncho) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Usuario')),
                    DataColumn(label: Text('Rol')),
                    DataColumn(label: Text('Estado')),
                  ],
                  rows: usuarios.map((u) {
                    final activo = u['activo'] as bool;
                    return DataRow(
                      cells: [
                        DataCell(Text(u['nombre'] as String)),
                        DataCell(Text(u['usuario'] as String)),
                        DataCell(Text(u['rol'] as String)),
                        DataCell(
                          Text(
                            activo ? 'Activo' : 'Inactivo',
                            style: TextStyle(
                              color: activo ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            }

            return ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final u = usuarios[index];
                final activo = u['activo'] as bool;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF1F4A7C).withOpacity(0.1),
                      child: const Icon(
                        Icons.person_outline,
                        color: Color(0xFF1F4A7C),
                      ),
                    ),
                    title: Text(
                      u['nombre'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Usuario: ${u['usuario']}\n'
                      'Rol: ${u['rol']}\n'
                      'Estado: ${activo ? 'Activo' : 'Inactivo'}',
                    ),
                    isThreeLine: true,
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
