const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/auth.routes');

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

module.exports = app;