class Compra {
  final String folio;
  final String fecha;
  final double total;
  final String estado;

  Compra({
    required this.folio,
    required this.fecha,
    required this.total,
    required this.estado,
  });

  factory Compra.fromJson(Map<String, dynamic> json) {
    return Compra(
      folio: json['folio'] ?? '',
      fecha: json['fecha'] ?? '',
      total: (json['total'] ?? 0).toDouble(),
      estado: json['estado'] ?? '',
    );
  }
}