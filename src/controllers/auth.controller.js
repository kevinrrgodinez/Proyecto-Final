const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const Usuario = require('../models/Usuario');
const Cliente = require('../models/Cliente');

// 🔐 Generar token
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

// 🔄 Normalizar rol (IMPORTANTE: MAYÚSCULAS)
function normalizarRol(rol) {
  const rolNormalizado = (rol || '').toString().trim().toLowerCase();

  if (rolNormalizado === 'admin' || rolNormalizado === 'administrador') {
    return 'ADMIN';
  }

  if (rolNormalizado === 'vendedor') {
    return 'VENDEDOR';
  }

  if (rolNormalizado === 'cliente') {
    return 'CLIENTE';
  }

  return 'CLIENTE';
}

// ✅ REGISTER
async function register(req, res) {
  try {
    const { nombre, correo, password, rol } = req.body;

    if (!nombre || !correo || !password) {
      return res.status(400).json({
        detail: 'Nombre, correo y contraseña son obligatorios',
      });
    }

    const correoNormalizado = correo.toLowerCase().trim();

    // Verificar si ya existe
    const usuarioExistente = await Usuario.findOne({
      correo: correoNormalizado,
    });

    if (usuarioExistente) {
      return res.status(400).json({
        detail: 'El usuario ya existe',
      });
    }

    // Encriptar contraseña 🔐
    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);

    const rolFinal = normalizarRol(rol);

    // Crear usuario
    const nuevoUsuario = new Usuario({
      nombre,
      correo: correoNormalizado,
      password: passwordHash,
      rol: rolFinal,
      activo: true,
      fecha_creacion: new Date(),
    });

    await nuevoUsuario.save();

    return res.status(201).json({
      mensaje: 'Usuario registrado correctamente',
      user: {
        id: nuevoUsuario._id,
        nombre: nuevoUsuario.nombre,
        correo: nuevoUsuario.correo,
        rol: rolFinal,
      },
    });
  } catch (error) {
    console.error('Error en register:', error);

    return res.status(500).json({
      detail: error.message, // 👈 ahora te muestra el error real si algo falla
    });
  }
}

// ✅ LOGIN
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
    console.log('ROL ENVIADO:', rolFrontend);

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

// ✅ ME (usuario autenticado)
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

// 📦 EXPORTS
module.exports = {
  register,
  login,
  me,
};