const bcrypt = require("bcryptjs");

const usuarios = [
  {
    id: 1,
    nombre: "Admin",
    correo: "admin@test.com",
    password: bcrypt.hashSync("123456", 10),
    rol: "ADMIN",
    activo: true,
    fecha_creacion: new Date()
  }
];

module.exports = usuarios;