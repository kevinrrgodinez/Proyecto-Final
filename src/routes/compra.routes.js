const express = require("express");
const router = express.Router();

const compraController = require("../controllers/compra.controller");

router.post("/", compraController.crearCompra);

module.exports = router;