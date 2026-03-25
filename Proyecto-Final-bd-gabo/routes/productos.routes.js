const express = require("express");
const router = express.Router();

const productosController = require("../controllers/productos.controller");
const { verificarToken, verificarRol } = require("../src/middlewares/auth.middleware");

// listar productos
router.get(
  "/",
  verificarToken,
  productosController.listarProductos
);

// crear producto (solo ADMIN)
router.post(
  "/",
  verificarToken,
  verificarRol("ADMIN"),
  productosController.crearProducto
);

module.exports = router;