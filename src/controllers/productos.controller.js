const productoService = require('../services/producto.service');

exports.listarProductos = async (req, res) => {
  try {
    const productos = await productoService.obtenerProductos();

    // 🔥 SOLO ACTIVOS
    const productosActivos = productos.filter(p => p.activo !== false);

    res.json(productosActivos);
  } catch (error) {
    console.error('Error obteniendo productos:', error.message);
    res.status(500).json({ msg: 'Error obteniendo productos' });
  }
};

exports.crearProducto = async (req, res) => {
  try {
    const producto = await productoService.crearProducto(req.body);
    res.status(201).json(producto);
  } catch (error) {
    console.error('Error creando producto:', error.message);
    res.status(500).json({ msg: 'Error creando producto' });
  }
};

// 🔥 STOCK BAJO (HU4)
exports.obtenerStockBajo = async (req, res) => {
  try {
    const productos = await productoService.obtenerProductos();

    const stockBajo = productos.filter(
      p => p.stock < 10 && p.activo !== false
    );

    res.json(stockBajo);
  } catch (error) {
    console.error('Error obteniendo productos con stock bajo:', error.message);
    res.status(500).json({ msg: 'Error obteniendo stock bajo' });
  }
};