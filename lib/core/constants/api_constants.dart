class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:3000'; // 👈 AGREGA ESTO
  static const String usuarios = '$backendBaseUrl/usuarios';

  static const String backendBaseUrl = 'http://127.0.0.1:3000';
  static const String productosBaseUrl = 'http://127.0.0.1:3000';

  static const String login = '$backendBaseUrl/auth/login';
  static const String me = '$backendBaseUrl/auth/me';

  static const String productos = '$productosBaseUrl/productos';
  static const String ventas = '$backendBaseUrl/ventas';
  static const String clientes = '$backendBaseUrl/clientes';
}