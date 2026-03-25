const mongoose = require('mongoose');

const clienteSchema = new mongoose.Schema(
  {
    nombre: {
      type: String,
      required: true,
      trim: true,
    },
    correo: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      lowercase: true,
    },
    password: {
      type: String,
      required: true,
    },
    telefono: {
      type: String,
      trim: true,
      default: '',
    },
    direccion: {
      type: String,
      trim: true,
      default: '',
    },
    rol: {
      type: String,
      default: 'CLIENTE',
    },
    activo: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
    versionKey: false,
    collection: 'clientes',
  }
);

module.exports = mongoose.model('Cliente', clienteSchema);