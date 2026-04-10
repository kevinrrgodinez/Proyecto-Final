import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../models/usuario.dart';

class AuthService {
  static Future<Usuario> iniciarSesion({
    required String usuario,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario': usuario,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Usuario.fromLoginResponse(data); // ✅ YA FUNCIONA
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['detail'] ?? 'Error al iniciar sesión');
    }
  }
}