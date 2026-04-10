import '../models/producto.dart';

class CarritoService {
  static final List<Producto> _carrito = [];

  static List<Producto> obtenerCarrito() {
    return _carrito;
  }

  static void agregarProducto(Producto producto) {
    _carrito.add(producto);
  }

  static void eliminarProducto(Producto producto) {
    _carrito.remove(producto);
  }

  static void limpiarCarrito() {
    _carrito.clear();
  }
}