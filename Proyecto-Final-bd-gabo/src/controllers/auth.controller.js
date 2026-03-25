const Usuario = require("../models/usuario.model");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

// REGISTRO
exports.register = async (req, res) => {
  try {
    const { nombre, correo, password } = req.body;

    const existe = await Usuario.findOne({ correo });

    if (existe) {
      return res.status(400).json({
        msg: "El usuario ya existe"
      });
    }

    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);

    const nuevoUsuario = new Usuario({
      nombre,
      correo,
      password: passwordHash
    });

    await nuevoUsuario.save();

    res.json({
      msg: "Usuario registrado correctamente"
    });

  } catch (error) {
    res.status(500).json({
      msg: "Error al registrar usuario"
    });
  }
};

// LOGIN 🔥 (AQUÍ ESTABA EL ERROR)
exports.login = async (req, res) => {
  try {
    const { correo, password } = req.body;

    const usuario = await Usuario.findOne({ correo });

    if (!usuario) {
      return res.status(400).json({
        msg: "Usuario no encontrado"
      });
    }

    const validPassword = await bcrypt.compare(password, usuario.password);

    if (!validPassword) {
      return res.status(400).json({
        msg: "Contraseña incorrecta"
      });
    }

    // 🔥 TOKEN CON ROL
    const token = jwt.sign(
      {
        id: usuario._id,
        rol: usuario.rol
      },
      process.env.JWT_SECRET,
      { expiresIn: "1h" }
    );

    res.json({
      msg: "Login correcto",
      token
    });

  } catch (error) {
    res.status(500).json({
      msg: "Error en login"
    });
  }
};