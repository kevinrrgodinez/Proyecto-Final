import '../models/usuario.dart';

class AuthService {
  static Future<Usuario?> iniciarSesion({
    required String usuario,
    required String password,
    required String rolSeleccionado,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    if (usuario.trim().isEmpty || password.trim().isEmpty) {
      return null;
    }

    // Simulación temporal por rol
    if (rolSeleccionado == 'Administrador') {
      return Usuario(usuario: usuario, rol: 'admin');
    } else if (rolSeleccionado == 'Vendedor') {
      return Usuario(usuario: usuario, rol: 'vendedor');
    } else {
      return Usuario(usuario: usuario, rol: 'cliente');
    }
  }
}
