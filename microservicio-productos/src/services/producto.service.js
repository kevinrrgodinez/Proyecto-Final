const pool = require('../config/db');

exports.obtenerProductos = async () => {
  const result = await pool.query(`
    SELECT 
      p.id,
      p.nombre,
      p.descripcion,
      i.stock,
      pr.precio_venta AS precio
    FROM productos p
    LEFT JOIN inventario i ON p.id = i.id_producto
    LEFT JOIN precios pr ON p.id = pr.id_producto
  `);

  return result.rows;
};