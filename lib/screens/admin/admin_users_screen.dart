import 'package:flutter/material.dart';
import '../../models/usuario.dart';
import '../../services/usuario_service.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  late Future<List<Usuario>> _futureUsuarios;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _futureUsuarios = UsuarioService.obtenerUsuarios();
  }

  void _recargar() {
    setState(() {
      _cargar();
    });
  }

  void _mostrarFormulario({Usuario? usuario}) {
    final nombreCtrl = TextEditingController(text: usuario?.nombre ?? '');
    final correoCtrl = TextEditingController(text: usuario?.correo ?? '');
    final passwordCtrl = TextEditingController();
    String rol = usuario?.rol ?? 'CLIENTE';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(usuario == null ? 'Nuevo Usuario' : 'Editar Usuario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: correoCtrl, decoration: const InputDecoration(labelText: 'Correo')),
            if (usuario == null)
              TextField(controller: passwordCtrl, decoration: const InputDecoration(labelText: 'Password')),
            DropdownButtonFormField<String>(
              value: rol,
              items: ['ADMIN', 'VENDEDOR', 'CLIENTE']
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (value) => rol = value!,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              try {
                if (usuario == null) {
                  await UsuarioService.crearUsuario(
                    nombreCtrl.text,
                    correoCtrl.text,
                    passwordCtrl.text,
                    rol,
                  );
                } else {
                  await UsuarioService.actualizarUsuario(
                    usuario.id,
                    Usuario(
                      id: usuario.id,
                      nombre: nombreCtrl.text,
                      correo: correoCtrl.text,
                      rol: rol,
                      telefono: usuario.telefono,
                      activo: usuario.activo,
                    ),
                  );
                }

                Navigator.pop(context);
                _recargar();
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('$e')));
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _eliminar(String id) async {
    await UsuarioService.eliminarUsuario(id);
    _recargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        actions: [
          IconButton(onPressed: _recargar, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: () => _mostrarFormulario(), icon: const Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder<List<Usuario>>(
        future: _futureUsuarios,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final usuarios = snapshot.data!;

          return ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (_, i) {
              final u = usuarios[i];

              return ListTile(
                title: Text(u.nombre),
                subtitle: Text('${u.correo} - ${u.rol}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _mostrarFormulario(usuario: u),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _eliminar(u.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}