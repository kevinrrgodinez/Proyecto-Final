import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../models/producto.dart';
import 'session_service.dart';

class ProductoService {

  // 🔐 Obtener headers con token
  static Future<Map<String, String>> _getHeaders() async {
    final session = await SessionService.obtenerSesion();
    final token = session?['token'] ?? '';

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // 📦 OBTENER PRODUCTOS
  static Future<List<Producto>> obtenerProductos() async {
    final headers = await _getHeaders();

    final response = await http.get(
      Uri.parse(ApiConstants.productos),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Producto.fromJson(item)).toList();
    } else {
      throw Exception(
        'Error al obtener productos: HTTP ${response.statusCode} - ${response.body}',
      );
    }
  }

  // ➕ CREAR PRODUCTO
  static Future<void> crearProducto(Producto producto) async {
    final headers = await _getHeaders();

    final response = await http.post(
      Uri.parse(ApiConstants.productos),
      headers: headers,
      body: jsonEncode(producto.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear producto: ${response.body}');
    }
  }

  // ✏️ ACTUALIZAR PRODUCTO
  static Future<void> actualizarProducto(String id, Producto producto) async {
    final headers = await _getHeaders();

    final response = await http.put(
      Uri.parse('${ApiConstants.productos}/$id'),
      headers: headers,
      body: jsonEncode(producto.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar producto: ${response.body}');
    }
  }

  // ❌ ELIMINAR PRODUCTO
  static Future<void> eliminarProducto(String id) async {
    final headers = await _getHeaders();

    final response = await http.delete(
      Uri.parse('${ApiConstants.productos}/$id'),
      headers: headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar producto: ${response.body}');
    }
  }

  // 📉 DESCONTAR STOCK
  static Future<void> descontarStock({
    required String idProducto,
    required int cantidad,
  }) async {
    final headers = await _getHeaders();

    final response = await http.put(
      Uri.parse('${ApiConstants.productos}/descontar/$idProducto'),
      headers: headers,
      body: jsonEncode({
        'cantidad': cantidad,
      }),
    );

    if (response.statusCode != 200) {
      String mensaje = 'Error al descontar stock';

      try {
        final data = jsonDecode(response.body);
        if (data['detail'] != null) {
          mensaje = data['detail'];
        }
      } catch (_) {}

      throw Exception(mensaje);
    }
  }
}