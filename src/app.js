const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/auth.routes');
const clientesRoutes = require('./routes/clientes.routes');
const ventasRoutes = require('./routes/ventas.routes');
const Usuario = require('./models/Usuario');
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
    mensaje: 'Backend general funcionando correctamente',
  });
});

app.use('/auth', authRoutes);
app.use('/clientes', clientesRoutes);
app.use('/ventas', ventasRoutes);
app.use('/usuarios', require('./routes/usuarios.routes'));
module.exports = app;