class Usuario {
  final String id;
  final String nombre;
  final String correo;
  final String rol;
  final String token; // ahora opcional
  final String telefono;
  final bool activo;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
    this.token = '', // ✅ FIX
    required this.telefono,
    required this.activo,
  });

  factory Usuario.fromLoginResponse(Map<String, dynamic> json) {
    final user = json['user'];

    return Usuario(
      id: user['id'].toString(),
      nombre: user['nombre'] ?? '',
      correo: user['usuario'] ?? '',
      rol: user['rol'] ?? '',
      token: json['token'] ?? '',
      telefono: user['telefono'] ?? '',
      activo: true,
    );
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'].toString(),
      nombre: json['nombre'] ?? '',
      correo: json['correo'] ?? '',
      rol: json['rol'] ?? '',
      telefono: json['telefono'] ?? '',
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'correo': correo,
      'rol': rol,
      'telefono': telefono,
      'activo': activo,
    };
  }
}