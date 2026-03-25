const mongoose = require("mongoose");

const UsuarioSchema = new mongoose.Schema({
  nombre: {
    type: String,
    required: true
  },
  correo: {
    type: String,
    required: true,
    unique: true
  },
  password: {
    type: String,
    required: true
  },
  rol: {
    type: String,
    enum: ["ADMIN", "VENDEDOR", "CLIENTE"],
    default: "CLIENTE"
  },
  telefono: {
    type: String
  },
  activo: {
    type: Boolean,
    default: true
  },
  fecha_creacion: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model("Usuario", UsuarioSchema);