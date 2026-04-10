const mongoose = require('mongoose');

const ProductoSchema = new mongoose.Schema({
  codigo: String,
  nombre: String,
  descripcion: String,
  precio_venta: Number,
  costo: Number,
  stock: Number,
  stock_minimo: Number,
  categoria: String,
  marca: String,
  unidad_medida: String,
  activo: {
    type: Boolean,
    default: true,
  },
});

module.exports = mongoose.model('Producto', ProductoSchema);