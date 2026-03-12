const productoService = require("../services/producto.service");

exports.listarProductos = async (req, res) => {
  try {
    const productos = await productoService.obtenerProductos();
    res.json(productos);
  } catch (error) {
    res.status(500).json({ msg: "Error obteniendo productos" });
  }
};

exports.crearProducto = async (req, res) => {
  try {
    const producto = await productoService.crearProducto(req.body);
    res.json(producto);
  } catch (error) {
    res.status(500).json({ msg: "Error creando producto" });
  }
};