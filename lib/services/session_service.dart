import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';

class SessionService {
  static Future<void> guardarSesion(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('user_id', usuario.id);
    await prefs.setString('user_nombre', usuario.nombre);
    await prefs.setString('user_usuario', usuario.usuario);
    await prefs.setString('user_rol', usuario.rol);
    await prefs.setString('user_token', usuario.token);
  }

  static Future<Map<String, dynamic>?> obtenerSesion() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('user_token');
    if (token == null || token.isEmpty) return null;

    return {
      'id': prefs.getInt('user_id') ?? 0,
      'nombre': prefs.getString('user_nombre') ?? '',
      'usuario': prefs.getString('user_usuario') ?? '',
      'rol': prefs.getString('user_rol') ?? '',
      'token': token,
    };
  }

  static Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_nombre');
    await prefs.remove('user_usuario');
    await prefs.remove('user_rol');
    await prefs.remove('user_token');
  }
} 