class Venta {

  final int id;
  final double total;
  final String fecha;

  Venta({
    required this.id,
    required this.total,
    required this.fecha,
  });

  factory Venta.fromJson(Map<String, dynamic> json) {

    return Venta(
      id: json['id'],
      total: (json['total']).toDouble(),
      fecha: json['fecha'] ?? "",
    );
  }

}