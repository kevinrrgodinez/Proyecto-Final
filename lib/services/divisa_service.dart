import 'dart:convert';
import 'package:http/http.dart' as http;

class DivisaInfo {
  final String codigo;
  final String nombre;
  final String simbolo;

  DivisaInfo({
    required this.codigo,
    required this.nombre,
    required this.simbolo,
  });

  String get etiqueta => nombre.isEmpty ? codigo : '$codigo - $nombre';
}

class DivisaConversion {
  final String base;
  final String target;
  final double rate;
  final String date;

  DivisaConversion({
    required this.base,
    required this.target,
    required this.rate,
    required this.date,
  });
}

class DivisaService {
  static Future<DivisaConversion> obtenerTasa({
    String base = 'MXN',
    required String target,
  }) async {
    if (base == target) {
      return DivisaConversion(
        base: base,
        target: target,
        rate: 1.0,
        date: '',
      );
    }

    final response = await http.get(
      Uri.parse(
        'https://api.frankfurter.dev/v2/rates?base=$base&quotes=$target',
      ),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('No se pudo obtener la tasa de cambio');
    }

    final data = jsonDecode(response.body);

    if (data is! List || data.isEmpty) {
      throw Exception('Respuesta inválida de la API de divisas');
    }

    final primerRegistro = Map<String, dynamic>.from(data.first);

    return DivisaConversion(
      base: primerRegistro['base']?.toString() ?? base,
      target: primerRegistro['quote']?.toString() ?? target,
      rate: (primerRegistro['rate'] ?? 1).toDouble(),
      date: primerRegistro['date']?.toString() ?? '',
    );
  }

  static Future<List<DivisaInfo>> obtenerMonedasDisponibles() async {
    final response = await http.get(
      Uri.parse('https://api.frankfurter.dev/v2/currencies'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('No se pudieron obtener las divisas');
    }

    final data = jsonDecode(response.body);

    if (data is! List) {
      throw Exception('Respuesta inválida de monedas');
    }

    final monedas = data
        .map((e) => Map<String, dynamic>.from(e))
        .map(
          (e) => DivisaInfo(
            codigo: e['iso_code']?.toString() ?? '',
            nombre: e['name']?.toString() ?? '',
            simbolo: e['symbol']?.toString() ?? '',
          ),
        )
        .where((m) => m.codigo.isNotEmpty)
        .toList();

    monedas.sort((a, b) => a.codigo.compareTo(b.codigo));
    return monedas;
  }
}