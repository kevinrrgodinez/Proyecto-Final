const express = require("express");
const router = express.Router();

const productosController = require("../controllers/producto.controller");
const { verificarToken, verificarRol } = require("../middlewares/auth.middleware");

// 🔹 Listar productos
router.get(
  "/",
  verificarToken,
  productosController.listarProductos
);

// 🔹 Crear producto (ADMIN)
router.post(
  "/",
  verificarToken,
  verificarRol("ADMIN"),
  productosController.crearProducto
);

// 🔹 Actualizar producto
router.put(
  "/:id",
  verificarToken,
  verificarRol("ADMIN"),
  productosController.actualizarProducto
);

// 🔹 Desactivar producto (borrado lógico)
router.delete(
  "/:id",
  verificarToken,
  verificarRol("ADMIN"),
  productosController.desactivarProducto
);

// 🔹 Productos con stock bajo
router.get(
  "/stock-bajo",
  verificarToken,
  verificarRol("ADMIN"),
  productosController.obtenerStockBajo
);

module.exports = router;