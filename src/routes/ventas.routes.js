const express = require('express');
const router = express.Router();

const ventasController = require('../controllers/ventas.controller');

router.get('/', ventasController.listarVentas);
router.post('/', ventasController.crearVenta);

module.exports = router;