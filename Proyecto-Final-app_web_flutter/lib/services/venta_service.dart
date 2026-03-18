import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/venta.dart';

class VentaService {

  static Future<List<Venta>> obtenerVentas() async {

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/ventas')
    );

    if (response.statusCode == 200) {

      final List data = json.decode(response.body);

      return data.map((e) => Venta.fromJson(e)).toList();

    } else {
      throw Exception("Error al cargar compras");
    }

  }

}