const bcrypt = require("bcryptjs");
const usuarios = require("../data/usuarios.mock");

// 🔹 Registrar usuario
exports.crearUsuario = (req, res) => {
  try {
    const { nombre, correo, password, rol, telefono } = req.body;

    // validar duplicado
    const existe = usuarios.find(u => u.correo === correo);
    if (existe) {
      return res.status(400).json({ msg: "El correo ya existe" });
    }

    const nuevoUsuario = {
      id: usuarios.length + 1,
      nombre,
      correo,
      password: bcrypt.hashSync(password, 10),
      rol,
      telefono: telefono || null,
      activo: true,
      fecha_creacion: new Date()
    };

    usuarios.push(nuevoUsuario);

    res.status(201).json({ msg: "Usuario creado", usuario: nuevoUsuario });

  } catch (error) {
    res.status(500).json({ msg: "Error al crear usuario" });
  }
};

// 🔹 Modificar usuario
exports.actualizarUsuario = (req, res) => {
  try {
    const { id } = req.params;
    const usuario = usuarios.find(u => u.id == id);

    if (!usuario) {
      return res.status(404).json({ msg: "Usuario no encontrado" });
    }

    const { nombre, correo, rol, activo } = req.body;

    if (nombre !== undefined) usuario.nombre = nombre;
    if (correo !== undefined) usuario.correo = correo;
    if (rol !== undefined) usuario.rol = rol;
    if (activo !== undefined) usuario.activo = activo;

    res.json({ msg: "Usuario actualizado", usuario });

  } catch (error) {
    res.status(500).json({ msg: "Error al actualizar" });
  }
};

// 🔹 Eliminar usuario (soft delete)
exports.eliminarUsuario = (req, res) => {
  try {
    const { id } = req.params;
    const usuario = usuarios.find(u => u.id == id);

    if (!usuario) {
      return res.status(404).json({ msg: "Usuario no encontrado" });
    }

    usuario.activo = false;

    res.json({ msg: "Usuario desactivado" });

  } catch (error) {
    res.status(500).json({ msg: "Error al eliminar" });
  }
};
// 🔹 Listar usuarios
exports.listarUsuarios = (req, res) => {
  try {
    const { rol, activo } = req.query;

    let resultado = [...usuarios];

    if (rol) {
      resultado = resultado.filter(u => u.rol === rol);
    }

    if (activo !== undefined) {
      const estado = activo === "true";
      resultado = resultado.filter(u => u.activo === estado);
    }

    res.json(resultado);
  } catch (error) {
    res.status(500).json({ msg: "Error al listar usuarios" });
  }
};

// 🔹 Obtener usuario por ID
exports.obtenerUsuario = (req, res) => {
  try {
    const { id } = req.params;

    const usuario = usuarios.find(u => u.id == id);

    if (!usuario) {
      return res.status(404).json({ msg: "Usuario no encontrado" });
    }

    res.json(usuario);
  } catch (error) {
    res.status(500).json({ msg: "Error al obtener usuario" });
  }
};

// 🔹 Activar / desactivar usuario
exports.cambiarEstadoUsuario = (req, res) => {
  try {
    const { id } = req.params;
    const { activo } = req.body;

    const usuario = usuarios.find(u => u.id == id);

    if (!usuario) {
      return res.status(404).json({ msg: "Usuario no encontrado" });
    }

    usuario.activo = activo;

    res.json({
      msg: "Estado actualizado",
      usuario
    });
  } catch (error) {
    res.status(500).json({ msg: "Error al cambiar estado" });
  }
};