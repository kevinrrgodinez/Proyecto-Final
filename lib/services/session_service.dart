import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';

class SessionService {
  static Future<void> guardarSesion(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_id', usuario.id);
    await prefs.setString('user_nombre', usuario.nombre);

    // 🔥 AQUÍ EL FIX
    await prefs.setString('user_usuario', usuario.correo); // ✅ FIXflutter

    await prefs.setString('user_rol', usuario.rol);

    // 🔥 token puede ser null
    await prefs.setString('user_token', usuario.token ?? '');
  }

  static Future<Map<String, dynamic>?> obtenerSesion() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('user_token');
    if (token == null || token.isEmpty) return null;

    return {
      'id': prefs.getString('user_id') ?? '',
      'nombre': prefs.getString('user_nombre') ?? '',
      'usuario': prefs.getString('user_usuario') ?? '',
      'rol': prefs.getString('user_rol') ?? '',
      'token': token,
    };
  }

  static Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}