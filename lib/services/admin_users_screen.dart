import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';

class UsuarioService {
  static Future<List<dynamic>> obtenerUsuarios() async {
    final response = await http.get(Uri.parse(ApiConstants.usuarios));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener usuarios');
    }
  }

  static Future<void> crearUsuario(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(ApiConstants.usuarios),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear usuario: ${response.body}');
    }
  }

  static Future<void> actualizarUsuario(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('${ApiConstants.usuarios}/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar usuario');
    }
  }

  static Future<void> eliminarUsuario(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.usuarios}/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar usuario');
    }
  }
}