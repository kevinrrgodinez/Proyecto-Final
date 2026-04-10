const express = require('express');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

// 🔥 rutas
const productoRoutes = require('./routes/producto.routes');

app.use('/', productoRoutes);

module.exports = app;