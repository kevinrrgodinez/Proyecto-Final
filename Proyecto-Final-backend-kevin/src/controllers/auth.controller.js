const jwt = require('jsonwebtoken');
const usuarios = require('../data/usuarios.mock');

function generarToken(usuario) {
  return jwt.sign(
    {
      id: usuario.id,
      usuario: usuario.usuario,
      rol: usuario.rol,
      nombre: usuario.nombre,
    },
    process.env.JWT_SECRET,
    { expiresIn: '8h' }
  );
}

function login(req, res) {
  const { usuario, password } = req.body;

  if (!usuario || !password) {
    return res.status(400).json({
      detail: 'Usuario y contraseña son obligatorios',
    });
  }

  const usuarioEncontrado = usuarios.find(
    (u) => u.usuario === usuario && u.password === password && u.activo
  );

  if (!usuarioEncontrado) {
    return res.status(401).json({
      detail: 'Credenciales inválidas',
    });
  }

  const token = generarToken(usuarioEncontrado);

  return res.json({
    token,
    user: {
      id: usuarioEncontrado.id,
      nombre: usuarioEncontrado.nombre,
      usuario: usuarioEncontrado.usuario,
      rol: usuarioEncontrado.rol,
    },
  });
}

function me(req, res) {
  return res.json({
    user: {
      id: req.user.id,
      nombre: req.user.nombre,
      usuario: req.user.usuario,
      rol: req.user.rol,
    },
  });
}

module.exports = {
  login,
  me,
};