const express = require("express");
const cors = require("cors");
const authRoutes = require("./routes/auth.routes");
const usuariosRoutes = require("./routes/usuarios.routes");
const productosRoutes = require("./routes/productos.routes");
const app = express();

// Middlewares
app.use(cors());
app.use(express.json());
app.use("/api/auth", authRoutes);
app.use("/api/productos", productosRoutes);
app.use("/api/usuarios", usuariosRoutes);
// Ruta de prueba
app.get("/health", (req, res) => {
  res.json({ status: "OK", message: "API funcionando" });
});

module.exports = app;