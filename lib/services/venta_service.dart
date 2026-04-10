import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/venta.dart';
import '../core/constants/api_constants.dart';
import 'session_service.dart';

class VentaService {

  // 🔥 OBTENER VENTAS
  static Future<List<Venta>> obtenerVentas() async {

    final session = await SessionService.obtenerSesion();

    final response = await http.get(
      Uri.parse(ApiConstants.ventas),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${session?['token'] ?? ''}',
      },
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      if (data is List) {
        return data.map((e) => Venta.fromJson(e)).toList();
      } else {
        throw Exception("Formato de ventas inválido");
      }

    } else {
      String mensaje = "Error al obtener ventas";

      try {
        final data = jsonDecode(response.body);
        if (data['detail'] != null) {
          mensaje = data['detail'];
        }
      } catch (_) {}

      throw Exception(mensaje);
    }
  }

  // 🔥 CREAR VENTA (opcional pero útil para HU)
  static Future<void> crearVenta(Map<String, dynamic> venta) async {

    final session = await SessionService.obtenerSesion();

    final response = await http.post(
      Uri.parse(ApiConstants.ventas),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${session?['token'] ?? ''}',
      },
      body: jsonEncode(venta),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Error al crear venta: ${response.body}");
    }
  }
}