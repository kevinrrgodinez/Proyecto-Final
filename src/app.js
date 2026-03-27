const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/auth.routes');
const clientesRoutes = require('./routes/clientes.routes');
const ventasRoutes = require('./routes/ventas.routes');
const usuariosRoutes = require('./routes/usuarios.routes');
const productosRoutes = require('./routes/productos.routes');
const compraRoutes = require('./routes/compra.routes');

const app = express();

app.use(
  cors({
    origin: true,
    credentials: true,
  })
);

app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    ok: true,
    mensaje: 'Backend general combinado funcionando correctamente',
  });
});

app.use('/auth', authRoutes);
app.use('/clientes', clientesRoutes);
app.use('/ventas', ventasRoutes);
app.use('/usuarios', usuariosRoutes);
app.use('/productos', productosRoutes);
app.use('/compras', compraRoutes);

module.exports = app;
