const bcrypt = require("bcryptjs");
const Usuario = require("../models/Usuario");

function normalizarRol(rol) {
  const valor = (rol || "").toString().trim().toUpperCase();

  if (valor === "ADMIN" || valor === "ADMINISTRADOR") return "ADMIN";
  if (valor === "VENDEDOR") return "VENDEDOR";
  if (valor === "CLIENTE") return "CLIENTE";

  return null;
}

exports.crearUsuario = async (req, res) => {
  try {
    const { nombre, correo, password, rol, telefono } = req.body;

    if (!nombre || !correo || !password) {
      return res.status(400).json({
        msg: "nombre, correo y password son obligatorios"
      });
    }

    const existe = await Usuario.findOne({
      correo: correo.toLowerCase().trim()
    });

    if (existe) {
      return res.status(400).json({ msg: "El correo ya existe" });
    }

    const rolFinal = rol ? normalizarRol(rol) : "CLIENTE";

    if (!rolFinal) {
      return res.status(400).json({
        msg: "Rol inválido. Debe ser ADMIN, VENDEDOR o CLIENTE"
      });
    }

    const nuevoUsuario = new Usuario({
      nombre: nombre.trim(),
      correo: correo.toLowerCase().trim(),
      password: bcrypt.hashSync(password, 10),
      rol: rolFinal,
      telefono: telefono || null,
      activo: true
    });

    await nuevoUsuario.save();

    res.status(201).json({
      msg: "Usuario creado",
      usuario: {
        id: nuevoUsuario._id,
        nombre: nuevoUsuario.nombre,
        correo: nuevoUsuario.correo,
        rol: nuevoUsuario.rol,
        telefono: nuevoUsuario.telefono,
        activo: nuevoUsuario.activo
      }
    });
  } catch (error) {
    console.error("ERROR AL CREAR USUARIO:", error);
    res.status(500).json({ msg: "Error al crear usuario", error: error.message });
  }
};

exports.listarUsuarios = async (req, res) => {
  try {
    const { rol, activo } = req.query;
    let filtro = {};

    if (rol) {
      const rolFinal = normalizarRol(rol);
      if (rolFinal) filtro.rol = rolFinal;
    }

    if (activo !== undefined) {
      filtro.activo = activo === "true";
    }

    const usuarios = await Usuario.find(filtro).sort({ createdAt: -1 });

    res.json(
      usuarios.map((u) => ({
        id: u._id,
        nombre: u.nombre,
        correo: u.correo,
        telefono: u.telefono || "",
        rol: u.rol,
        activo: u.activo
      }))
    );
  } catch (error) {
    res.status(500).json({ msg: "Error al listar usuarios", error: error.message });
  }
};

exports.obtenerUsuario = async (req, res) => {
  try {
    const { id } = req.params;
    const usuario = await Usuario.findById(id);

    if (!usuario) {
      return res.status(404).json({ msg: "Usuario no encontrado" });
    }

    res.json(usuario);
  } catch (error) {
    res.status(500).json({ msg: "Error al obtener usuario", error: error.message });
  }
};

exports.actualizarUsuario = async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, correo, rol, activo } = req.body;

    const usuario = await Usuario.findById(id);

    if (!usuario) {
      return res.status(404).json({ msg: "Usuario no encontrado" });
    }

    if (nombre !== undefined) usuario.nombre = nombre.trim();
    if (correo !== undefined) usuario.correo = correo.toLowerCase().trim();

    if (rol !== undefined) {
      const rolFinal = normalizarRol(rol);

      if (!rolFinal) {
        return res.status(400).json({
          msg: "Rol inválido. Debe ser ADMIN, VENDEDOR o CLIENTE"
        });
      }

      usuario.rol = rolFinal;
    }

    if (activo !== undefined) usuario.activo = activo;

    await usuario.save();

    res.json({
      msg: "Usuario actualizado",
      usuario
    });
  } catch (error) {
    res.status(500).json({ msg: "Error al actualizar usuario", error: error.message });
  }
};

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
    res.status(500).json({ msg: "Error al cambiar estado", error: error.message });
  }
};

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
    res.status(500).json({ msg: "Error al eliminar usuario", error: error.message });
  }
};