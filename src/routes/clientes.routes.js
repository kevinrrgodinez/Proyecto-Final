const express = require('express');
const router = express.Router();

const clientesController = require('../controllers/clientes.controller');

router.get('/', clientesController.listarClientes);
router.post('/', clientesController.crearCliente);

module.exports = router;