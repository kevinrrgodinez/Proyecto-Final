const { obtenerTipoCambio } = require('../services/divisa.service');

exports.crearCompra = async (req, res) => {
  try {
    const { producto, precio, cantidad } = req.body;

    if (!producto || precio == null || cantidad == null) {
      return res.status(400).json({ msg: 'producto, precio y cantidad son obligatorios' });
    }

    const total = Number(precio) * Number(cantidad);
    const divisas = await obtenerTipoCambio();
    const totalMXN = total * Number(divisas.MXN || 17.0);

    const factura = {
      producto,
      cantidad: Number(cantidad),
      totalUSD: total,
      totalMXN,
      fecha: new Date()
    };

    res.json({
      mensaje: 'Compra realizada',
      factura
    });
  } catch (error) {
    console.error('Error al procesar compra:', error.message);
    res.status(500).json({ msg: 'Error al procesar compra' });
  }
};
