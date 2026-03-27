import '../models/producto.dart';

class CarritoItem {
  final Producto producto;
  int cantidad;

  CarritoItem({
    required this.producto,
    this.cantidad = 1,
  });

  double get subtotal => producto.precioVenta * cantidad;
}

class CarritoService {
  static final List<CarritoItem> _carrito = [];

  static List<CarritoItem> obtenerCarrito() {
    return _carrito;
  }

  static void agregarProducto(Producto producto, {int cantidad = 1}) {
    final index = _carrito.indexWhere(
      (item) => item.producto.id == producto.id,
    );

    if (index != -1) {
      final nuevaCantidad = _carrito[index].cantidad + cantidad;
      _carrito[index].cantidad =
          nuevaCantidad > producto.stock ? producto.stock : nuevaCantidad;
    } else {
      _carrito.add(
        CarritoItem(
          producto: producto,
          cantidad: cantidad > producto.stock ? producto.stock : cantidad,
        ),
      );
    }
  }

  static void eliminarProducto(Producto producto) {
    _carrito.removeWhere((item) => item.producto.id == producto.id);
  }

  static void aumentarCantidad(Producto producto) {
    final index = _carrito.indexWhere(
      (item) => item.producto.id == producto.id,
    );

    if (index != -1 && _carrito[index].cantidad < producto.stock) {
      _carrito[index].cantidad++;
    }
  }

  static void disminuirCantidad(Producto producto) {
    final index = _carrito.indexWhere(
      (item) => item.producto.id == producto.id,
    );

    if (index != -1) {
      if (_carrito[index].cantidad > 1) {
        _carrito[index].cantidad--;
      } else {
        _carrito.removeAt(index);
      }
    }
  }

  static void actualizarCantidad(Producto producto, int cantidad) {
    final index = _carrito.indexWhere(
      (item) => item.producto.id == producto.id,
    );

    if (index != -1) {
      if (cantidad <= 0) {
        _carrito.removeAt(index);
      } else {
        _carrito[index].cantidad =
            cantidad > producto.stock ? producto.stock : cantidad;
      }
    }
  }

  static int totalProductos() {
    return _carrito.fold(0, (sum, item) => sum + item.cantidad);
  }

  static double totalCarrito() {
    return _carrito.fold(0, (sum, item) => sum + item.subtotal);
  }

  static void limpiarCarrito() {
    _carrito.clear();
  }
}