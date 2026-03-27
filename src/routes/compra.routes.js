const express = require('express');
const router = express.Router();
const compraController = require('../controllers/compra.controller');
const authMiddleware = require('../middlewares/auth.middleware');

router.post('/', authMiddleware, compraController.crearCompra);

module.exports = router;
