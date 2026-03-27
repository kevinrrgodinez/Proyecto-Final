const express = require("express");
const router = express.Router();
const usuariosController = require("../controllers/usuarios.controller");

router.post("/", usuariosController.crearUsuario);
router.get("/", usuariosController.listarUsuarios);
router.get("/:id", usuariosController.obtenerUsuario);
router.put("/:id", usuariosController.actualizarUsuario);
router.patch("/:id/estado", usuariosController.cambiarEstadoUsuario);
router.delete("/:id", usuariosController.eliminarUsuario);

module.exports = router;