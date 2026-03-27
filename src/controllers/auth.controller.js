const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const Usuario = require('../models/Usuario');
const Cliente = require('../models/Cliente');

function generarToken(usuario) {
  return jwt.sign(
    {
      id: usuario._id,
      correo: usuario.correo,
      rol: usuario.rol,
      nombre: usuario.nombre,
    },
    process.env.JWT_SECRET,
    { expiresIn: '8h' }
  );
}

function normalizarRol(rol) {
  const rolNormalizado = (rol || '').toString().trim().toLowerCase();

  if (rolNormalizado === 'admin' || rolNormalizado === 'administrador') {
    return 'admin';
  }

  if (rolNormalizado === 'vendedor') {
    return 'vendedor';
  }

  if (rolNormalizado === 'cliente') {
    return 'cliente';
  }

  return 'cliente';
}

async function login(req, res) {
  try {
    const { usuario, password } = req.body;

    if (!usuario || !password) {
      return res.status(400).json({
        detail: 'Usuario y contraseña son obligatorios',
      });
    }

    const correoBuscado = usuario.toLowerCase().trim();

    let usuarioEncontrado = await Usuario.findOne({
      correo: correoBuscado,
      activo: { $ne: false },
    });

    let origen = 'usuarios';

    if (!usuarioEncontrado) {
      usuarioEncontrado = await Cliente.findOne({
        correo: correoBuscado,
        activo: { $ne: false },
      });
      origen = 'clientes';
    }

    if (!usuarioEncontrado) {
      return res.status(401).json({
        detail: 'Credenciales inválidas',
      });
    }

    const passwordValida = await bcrypt.compare(
      password,
      usuarioEncontrado.password
    );

    if (!passwordValida) {
      return res.status(401).json({
        detail: 'Credenciales inválidas',
      });
    }

    const rolFrontend = normalizarRol(usuarioEncontrado.rol);
    const token = generarToken(usuarioEncontrado);

    console.log('LOGIN DESDE:', origen);
    console.log('ROL EN BD:', usuarioEncontrado.rol);
    console.log('ROL ENVIADO A FLUTTER:', rolFrontend);

    return res.json({
      token,
      user: {
        id: usuarioEncontrado._id,
        nombre: usuarioEncontrado.nombre,
        usuario: usuarioEncontrado.correo,
        rol: rolFrontend,
      },
    });
  } catch (error) {
    console.error('Error en login:', error);
    return res.status(500).json({
      detail: 'Error al iniciar sesión',
    });
  }
}

function me(req, res) {
  const rolFrontend = normalizarRol(req.user.rol);

  return res.json({
    user: {
      id: req.user.id,
      nombre: req.user.nombre,
      usuario: req.user.correo,
      rol: rolFrontend,
    },
  });
}

module.exports = {
  login,
  me,
};