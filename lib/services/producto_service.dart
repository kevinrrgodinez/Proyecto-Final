import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../models/producto.dart';

class ProductoService {
  static Future<List<Producto>> obtenerProductos() async {
    final response = await http.get(Uri.parse(ApiConstants.productos));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Producto.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener productos: HTTP ${response.statusCode}');
    }
  }

  static Future<void> descontarStock({
    required int idProducto,
    required int cantidad,
  }) async {
    final response = await http.put(
      Uri.parse('${ApiConstants.productos}/descontar/$idProducto'),
      headers: {
        'Content-Type': 'application/json',
      },
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
