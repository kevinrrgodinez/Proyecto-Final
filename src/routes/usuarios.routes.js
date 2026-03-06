const express = require("express");
const router = express.Router();

const usuariosController = require("../controllers/usuarios.controller");
const { verificarToken, verificarRol } = require("../middlewares/auth.middleware");

// Solo ADMIN puede gestionar usuarios

router.post(
  "/",
  verificarToken,
  verificarRol("ADMIN"),
  usuariosController.crearUsuario
);

router.put(
  "/:id",
  verificarToken,
  verificarRol("ADMIN"),
  usuariosController.actualizarUsuario
);

router.delete(
  "/:id",
  verificarToken,
  verificarRol("ADMIN"),
  usuariosController.eliminarUsuario
);

// 🔹 Listar usuarios
router.get(
  "/",
  verificarToken,
  verificarRol("ADMIN"),
  usuariosController.listarUsuarios
);

// 🔹 Obtener por ID
router.get(
  "/:id",
  verificarToken,
  verificarRol("ADMIN"),
  usuariosController.obtenerUsuario
);

// 🔹 Cambiar estado
router.patch(
  "/:id/estado",
  verificarToken,
  verificarRol("ADMIN"),
  usuariosController.cambiarEstadoUsuario
);

module.exports = router;
