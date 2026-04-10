class Producto {
  final String id; // ✅ CAMBIO A STRING
  final String codigo;
  final String nombre;
  final String descripcion;
  final double precioVenta;
  final double costo;
  final int stock;
  final int stockMinimo;
  final String categoria;
  final String marca;
  final String unidadMedida;
  final bool activo;

  Producto({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.precioVenta,
    required this.costo,
    required this.stock,
    required this.stockMinimo,
    required this.categoria,
    required this.marca,
    required this.unidadMedida,
    required this.activo,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
  return Producto(
    id: json['id']?.toString() ?? '',
    codigo: json['codigo'] ?? '',
    nombre: json['nombre'] ?? '',
    descripcion: json['descripcion'] ?? '',
    precioVenta: double.tryParse(json['precio_venta'].toString()) ?? 0.0,
    costo: double.tryParse(json['costo'].toString()) ?? 0.0,
    stock: json['stock'] ?? 0,
    stockMinimo: json['stock_minimo'] ?? 0,
    categoria: json['categoria'] ?? '',
    marca: json['marca'] ?? '',
    unidadMedida: json['unidad_medida'] ?? '',
    activo: json['activo'] ?? false,
  );
}

  Map<String, dynamic> toJson() {
    return {
      // ⚠️ normalmente NO mandas _id al crear, pero lo dejo por si editas
      '_id': id,
      'codigo': codigo,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio_venta': precioVenta,
      'costo': costo,
      'stock': stock,
      'stock_minimo': stockMinimo,
      'categoria': categoria,
      'marca': marca,
      'unidad_medida': unidadMedida,
      'activo': activo,
    };
  }
}