const express = require("express");
const { Pool } = require("pg");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(cors());

// conexión a PostgreSQL
const pool = new Pool({
  user: "postgres",        // tu usuario de postgres
  host: "localhost",
  database: "ferreteria_db", // cambia por el nombre de tu BD
  password: "12345", // tu contraseña
  port: 5432
});

// obtener todos los productos
app.get("/productos", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM productos");
    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error obteniendo productos" });
  }
});

// obtener producto por id
app.get("/productos/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      "SELECT * FROM productos WHERE id = $1",
      [id]
    );

    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ msg: "Error obteniendo producto" });
  }
});

// crear producto
app.post("/productos", async (req, res) => {
  try {
    const { nombre, precio } = req.body;

    const result = await pool.query(
      "INSERT INTO productos (nombre, precio) VALUES ($1,$2) RETURNING *",
      [nombre, precio]
    );

    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ msg: "Error creando producto" });
  }
});

// actualizar producto
app.put("/productos/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, precio } = req.body;

    const result = await pool.query(
      "UPDATE productos SET nombre=$1, precio=$2 WHERE id=$3 RETURNING *",
      [nombre, precio, id]
    );

    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ msg: "Error actualizando producto" });
  }
});

// eliminar producto
app.delete("/productos/:id", async (req, res) => {
  try {
    const { id } = req.params;

    await pool.query("DELETE FROM productos WHERE id=$1", [id]);

    res.json({ msg: "Producto eliminado" });
  } catch (error) {
    res.status(500).json({ msg: "Error eliminando producto" });
  }
});

// iniciar servidor
app.listen(8000, () => {
  console.log("Microservicio de productos corriendo en puerto 8000");
});