const Venta = require('../models/Venta');

const PRODUCTOS_API_URL = 'http://127.0.0.1:8010/productos';

function generarFolio() {
  return `VTA-${Date.now()}`;
}

async function listarVentas(req, res) {
  try {
    const ventas = await Venta.find().sort({ fecha: -1 });
    res.json(ventas);
  } catch (error) {
    console.error('Error al obtener ventas:', error);
    res.status(500).json({ detail: 'Error al obtener ventas' });
  }
}

async function crearVenta(req, res) {
  try {
    const { vendedor, cliente, metodo_pago, items } = req.body;

    if (!vendedor || !metodo_pago || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({
        detail: 'vendedor, metodo_pago e items son obligatorios',
      });
    }

    let total = 0;
    const itemsConSubtotal = [];

    for (const item of items) {
      if (!item.id_producto || !item.cantidad) {
        return res.status(400).json({
          detail: 'Cada item debe incluir id_producto y cantidad',
        });
      }

      const cantidad = Number(item.cantidad);

      if (cantidad <= 0) {
        return res.status(400).json({
          detail: 'La cantidad debe ser mayor a 0',
        });
      }

      // 1. Obtener producto desde microservicio
      const responseProducto = await fetch(
        `${PRODUCTOS_API_URL}/${item.id_producto}`
      );

      if (!responseProducto.ok) {
        return res.status(404).json({
          detail: `Producto con id ${item.id_producto} no encontrado`,
        });
      }

      const producto = await responseProducto.json();

      if (producto.stock < cantidad) {
        return res.status(400).json({
          detail: `Stock insuficiente para ${producto.nombre}`,
        });
      }

      const precioUnitario = Number(producto.precio_venta);
      const subtotal = cantidad * precioUnitario;
      total += subtotal;

      itemsConSubtotal.push({
        id_producto: producto.id,
        codigo: producto.codigo,
        nombre: producto.nombre,
        cantidad,
        precio_unitario: precioUnitario,
        subtotal,
      });
    }

    // 2. Guardar venta en Mongo
    const nuevaVenta = await Venta.create({
      folio: generarFolio(),
      vendedor,
      cliente: cliente || 'Cliente mostrador',
      metodo_pago,
      total,
      items: itemsConSubtotal,
    });

    // 3. Descontar stock en microservicio
    for (const item of itemsConSubtotal) {
      const responseDescuento = await fetch(
        `${PRODUCTOS_API_URL}/descontar/${item.id_producto}`,
        {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            cantidad: item.cantidad,
          }),
        }
      );

      if (!responseDescuento.ok) {
        console.error(`No se pudo descontar stock del producto ${item.id_producto}`);
      }
    }

    res.status(201).json(nuevaVenta);
  } catch (error) {
    console.error('Error al crear venta:', error);
    res.status(500).json({ detail: 'Error al crear venta' });
  }
}

module.exports = {
  listarVentas,
  crearVenta,
};