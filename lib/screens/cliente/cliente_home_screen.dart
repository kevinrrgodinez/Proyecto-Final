import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

class ClienteHomeScreen extends StatelessWidget {
  const ClienteHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final opciones = [
      _ClienteOption(
        titulo: 'Catálogo',
        subtitulo: 'Explora productos disponibles',
        icono: Icons.storefront_outlined,
        ruta: AppRoutes.clienteCatalogo,
      ),
      _ClienteOption(
        titulo: 'Mis compras',
        subtitulo: 'Consulta tu historial de compras',
        icono: Icons.shopping_bag_outlined,
        ruta: AppRoutes.clienteCompras,
      ),
      _ClienteOption(
        titulo: 'Perfil',
        subtitulo: 'Editar datos personales',
        icono: Icons.person_outline,
        ruta: AppRoutes.clientePerfil,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cliente'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              'Salir',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 900
                ? 3
                : constraints.maxWidth > 600
                    ? 2
                    : 1;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bienvenido',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F4A7C),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Consulta el catálogo y revisa tus compras.',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.builder(
                    itemCount: opciones.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                    ),
                    itemBuilder: (context, index) {
                      final item = opciones[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          if (item.ruta.isNotEmpty) {
                            Navigator.pushNamed(context, item.ruta);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.titulo} aún no disponible'),
                              ),
                            );
                          }
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor:
                                      const Color(0xFF1F4A7C).withOpacity(0.1),
                                  child: Icon(
                                    item.icono,
                                    color: const Color(0xFF1F4A7C),
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  item.titulo,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.subtitulo,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ClienteOption {
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final String ruta;

  _ClienteOption({
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    required this.ruta,
  });
}
