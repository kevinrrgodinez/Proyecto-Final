const bcrypt = require("bcryptjs");
const Usuario = require("../models/usuario.model");

// 🔹 Registrar usuario
exports.crearUsuario = async (req, res) => {
  try {
    const { nombre, correo, password, rol, telefono } = req.body;

    const existe = await Usuario.findOne({ correo });

    if (existe) {
      return res.status(400).json({ msg: "El correo ya existe" });
    }

    const nuevoUsuario = new Usuario({
      nombre,
      correo,
      password: bcrypt.hashSync(password, 10),
      rol,
      telefono: telefono || null,
      activo: true
    });

    await nuevoUsuario.save();

    res.status(201).json({
      msg: "Usuario creado",
      usuario: nuevoUsuario
    });

  } catch (error) {
    res.status(500).json({ msg: "Error al crear usuario", error });
  }
};

// 🔹 Modificar usuario
exports.actualizarUsuario = async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, correo, rol, activo } = req.body;

    const usuario = await Usuario.findById(id);

    if (!usuario) {
      return res.status(404).json({ msg: "Usuario no encontrado" });
    }

    if (nombre !== undefined) usuario.nombre = nombre;
    if (correo !== undefined) usuario.correo = correo;
    if (rol !== undefined) usuario.rol = rol;
    if (activo !== undefined) usuario.activo = activo;

    await usuario.save();

    res.json({
      msg: "Usuario actualizado",
      usuario
    });

  } catch (error) {
    res.status(500).json({ msg: "Error al actualizar usuario" });
  }
};

// 🔹 Eliminar usuario (soft delete)
exports.eliminarUsuario = async (req, res) => {
  try {
    const { id } = req.params;

    const usuario = await Usuario.findById(id);

    if (!usuario) {
      return res.status(404).json({ msg: "Usuario no encontrado" });
    }

    usuario.activo = false;
    await usuario.save();

    res.json({ msg: "Usuario desactivado" });

  } catch (error) {
    res.status(500).json({ msg: "Error al eliminar usuario" });
  }
};

// 🔹 Listar usuarios
exports.listarUsuarios = async (req, res) => {
  try {
    const { rol, activo } = req.query;

    let filtro = {};

    if (rol) {
      filtro.rol = rol;
    }

    if (activo !== undefined) {
      filtro.activo = activo === "true";
    }

    const usuarios = await Usuario.find(filtro);

    res.json(usuarios);

  } catch (error) {
    res.status(500).json({ msg: "Error al listar usuarios" });
  }
};

// 🔹 Obtener usuario por ID
exports.obtenerUsuario = async (req, res) => {
  try {
    const { id } = req.params;

    const usuario = await Usuario.findById(id);

    if (!usuario) {
      return res.status(404).json({ msg: "Usuario no encontrado" });
    }

    res.json(usuario);

  } catch (error) {
    res.status(500).json({ msg: "Error al obtener usuario" });
  }
};

// 🔹 Activar / desactivar usuario
exports.cambiarEstadoUsuario = async (req, res) => {
  try {
    const { id } = req.params;
    const { activo } = req.body;

    const usuario = await Usuario.findById(id);

    if (!usuario) {
      return res.status(404).json({ msg: "Usuario no encontrado" });
    }

    usuario.activo = activo;
    await usuario.save();

    res.json({
      msg: "Estado actualizado",
      usuario
    });

  } catch (error) {
    res.status(500).json({ msg: "Error al cambiar estado" });
  }
};