import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/compra.dart';
import '../core/constants/api_constants.dart';

class CompraService {

  static Future<List<Compra>> obtenerCompras() async {

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/ventas')
    );

    if (response.statusCode == 200) {

      final List data = jsonDecode(response.body);

      return data.map((e) => Compra.fromJson(e)).toList();

    } else {
      throw Exception("Error al obtener compras");
    }
  }
}