import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const nombre = 'Ana López';
    const correo = 'ana.cliente@email.com';
    const telefono = '7711234567';
    const direccion = 'Pachuca, Hidalgo';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi perfil'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor:
                          const Color(0xFF1F4A7C).withOpacity(0.1),
                      child: const Icon(
                        Icons.person,
                        size: 42,
                        color: Color(0xFF1F4A7C),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      nombre,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Cliente registrado',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 24),
                    _PerfilDato(
                      icono: Icons.email_outlined,
                      titulo: 'Correo',
                      valor: correo,
                    ),
                    _PerfilDato(
                      icono: Icons.phone_outlined,
                      titulo: 'Teléfono',
                      valor: telefono,
                    ),
                    _PerfilDato(
                      icono: Icons.location_on_outlined,
                      titulo: 'Dirección',
                      valor: direccion,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Edición de perfil próximamente',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Editar perfil'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PerfilDato extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String valor;

  const _PerfilDato({
    required this.icono,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF1F4A7C).withOpacity(0.08),
        child: Icon(icono, color: const Color(0xFF1F4A7C)),
      ),
      title: Text(
        titulo,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(valor),
    );
  }
}
