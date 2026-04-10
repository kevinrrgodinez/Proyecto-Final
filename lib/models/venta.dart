class Venta {
  final String id; // 🔥 ahora STRING
  final String? usuarioId;
  final double total;
  final String? fecha;

  Venta({
    required this.id,
    this.usuarioId,
    required this.total,
    this.fecha,
  });

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      usuarioId: json['usuario_id']?.toString(),
      total: (json['total'] ?? 0).toDouble(),
      fecha: json['fecha']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'total': total,
      'fecha': fecha,
    };
  }
}