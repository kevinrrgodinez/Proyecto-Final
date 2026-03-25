const mongoose = require('mongoose');

const ProductoSchema = new mongoose.Schema({
    nombre: { type: String, required: true },
    precio: { type: Number, required: true, min: 0 },
    stock:  { type: Number, required: true, default: 0, min: 0 },
    activo: { type: Boolean, default: true }
});

module.exports = mongoose.model('Producto', ProductoSchema);