import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../models/usuario.dart';

class UsuarioService {
  static String get url => '${ApiConstants.baseUrl}/usuarios';

  static Future<List<Usuario>> obtenerUsuarios() async {
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Usuario.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener usuarios');
    }
  }

  static Future<void> crearUsuario(
      String nombre, String correo, String password, String rol) async {
    final res = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'correo': correo,
        'password': password,
        'rol': rol,
      }),
    );

    if (res.statusCode != 201) {
      throw Exception('Error al crear usuario');
    }
  }

  static Future<void> actualizarUsuario(
      String id, Usuario usuario) async {
    final res = await http.put(
      Uri.parse('$url/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );

    if (res.statusCode != 200) {
      throw Exception('Error al actualizar usuario');
    }
  }

  static Future<void> eliminarUsuario(String id) async {
    final res = await http.delete(Uri.parse('$url/$id'));

    if (res.statusCode != 200) {
      throw Exception('Error al eliminar usuario');
    }
  }
}