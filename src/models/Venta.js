const mongoose = require('mongoose');

const ventaItemSchema = new mongoose.Schema(
  {
    id_producto: {
      type: Number,
      required: true,
    },
    codigo: {
      type: String,
      required: true,
    },
    nombre: {
      type: String,
      required: true,
    },
    cantidad: {
      type: Number,
      required: true,
      min: 1,
    },
    precio_unitario: {
      type: Number,
      required: true,
      min: 0,
    },
    subtotal: {
      type: Number,
      required: true,
      min: 0,
    },
  },
  { _id: false }
);

const ventaSchema = new mongoose.Schema(
  {
    folio: {
      type: String,
      required: true,
      unique: true,
    },
    fecha: {
      type: Date,
      default: Date.now,
    },
    estado: {
      type: String,
      default: 'confirmada',
    },
    vendedor: {
      type: String,
      required: true,
    },
    cliente: {
      type: String,
      default: 'Cliente mostrador',
    },
    metodo_pago: {
      type: String,
      required: true,
    },
    total: {
      type: Number,
      required: true,
      min: 0,
    },
    items: {
      type: [ventaItemSchema],
      required: true,
      validate: [(arr) => arr.length > 0, 'La venta debe tener al menos un item'],
    },
  },
  {
    timestamps: true,
    versionKey: false,
  }
);

module.exports = mongoose.model('Venta', ventaSchema);