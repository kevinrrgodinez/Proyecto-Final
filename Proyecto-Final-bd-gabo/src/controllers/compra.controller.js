const { obtenerTipoCambio } = require("../services/divisa.service");

exports.crearCompra = async (req, res) => {

  try {

    const { producto, precio, cantidad } = req.body;

    const total = precio * cantidad;

    const divisas = await obtenerTipoCambio();

    const totalMXN = total * divisas.MXN;

    const factura = {
      producto,
      cantidad,
      totalUSD: total,
      totalMXN: totalMXN,
      fecha: new Date()
    };

    res.json({
      mensaje: "Compra realizada",
      factura
    });

  } catch (error) {

    res.status(500).json({
      msg: "Error al procesar compra"
    });

  }

};