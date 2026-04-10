const productoService = require('../services/producto.service');

exports.getProductos = async (req, res) => {
  try {
    const productos = await productoService.obtenerProductos();

    res.json(productos);
  } catch (error) {
    console.log("🔥 ERROR COMPLETO:", error); // 👈 esto FORZA a mostrar todo

    res.status(500).json({
      msg: 'Error obteniendo productos',
      error: error.message,
      detalle: error // 👈 esto lo manda al navegador sí o sí
    });
  }
};