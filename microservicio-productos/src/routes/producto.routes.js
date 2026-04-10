const express = require('express');
const router = express.Router();
const pool = require('../config/db');

router.get('/productos', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        p.id,
        p.nombre,
        p.descripcion,
        i.stock,
        pr.precio_venta
      FROM productos p
      LEFT JOIN inventario i ON p.id = i.id_producto
      LEFT JOIN precios pr ON p.id = pr.id_producto
    `);

    res.json(result.rows);

  } catch (error) {
    console.error('🔥 ERROR REAL:', error);

    res.status(500).json({
      msg: 'Error obteniendo productos',
      error: error.message
    });
  }
});

module.exports = router;