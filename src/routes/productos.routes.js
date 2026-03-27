const express = require('express');
const router = express.Router();
const { soloAdmin } = require('../middlewares/roles.middleware');

const productosController = require('../controllers/productos.controller');
const authMiddleware = require('../middlewares/auth.middleware');

router.get('/', authMiddleware, productosController.listarProductos);
router.post('/', authMiddleware, soloAdmin, productosController.crearProducto);

// 🔥 NUEVO ENDPOINT
router.get('/stock-bajo', authMiddleware, productosController.obtenerStockBajo);

module.exports = router;