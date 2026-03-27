const bcrypt = require('bcryptjs');
const Cliente = require('../models/Cliente');

async function listarClientes(req, res) {
  try {
    const { activo } = req.query;
    const filtro = {};

    if (activo !== undefined) {
      filtro.activo = activo === 'true';
    }

    const clientes = await Cliente.find(filtro).sort({ createdAt: -1 });

    res.json(
      clientes.map((c) => ({
        id: c._id,
        nombre: c.nombre,
        correo: c.correo,
        telefono: c.telefono || '',
        direccion: c.direccion || '',
        rol: c.rol,
        activo: c.activo,
      }))
    );
  } catch (error) {
    console.error('Error al obtener clientes:', error);
    res.status(500).json({
      detail: 'Error al obtener clientes',
      error: error.message,
    });
  }
}

async function crearCliente(req, res) {
  try {
    console.log('ENTRO A /clientes');
    console.log('BODY CLIENTE:', req.body);

    const { nombre, correo, password, telefono, direccion } = req.body;

    if (!nombre || !correo || !password) {
      return res.status(400).json({
        detail: 'nombre, correo y password son obligatorios',
      });
    }

    const correoNormalizado = correo.toLowerCase().trim();

    const existe = await Cliente.findOne({
      correo: correoNormalizado,
    });

    if (existe) {
      return res.status(400).json({
        detail: 'El correo ya existe en clientes',
      });
    }

    const nuevoCliente = await Cliente.create({
      nombre: nombre.trim(),
      correo: correoNormalizado,
      password: bcrypt.hashSync(password, 10),
      telefono: (telefono || '').trim(),
      direccion: (direccion || '').trim(),
      rol: 'CLIENTE',
      activo: true,
    });

    console.log('CLIENTE GUARDADO EN COLECCION clientes:', {
      id: nuevoCliente._id,
      nombre: nuevoCliente.nombre,
      correo: nuevoCliente.correo,
      rol: nuevoCliente.rol,
    });

    res.status(201).json({
      msg: 'Cliente creado',
      cliente: {
        id: nuevoCliente._id,
        nombre: nuevoCliente.nombre,
        correo: nuevoCliente.correo,
        telefono: nuevoCliente.telefono,
        direccion: nuevoCliente.direccion,
        rol: nuevoCliente.rol,
        activo: nuevoCliente.activo,
      },
    });
  } catch (error) {
    console.error('Error al crear cliente:', error);
    res.status(500).json({
      detail: 'Error al crear cliente',
      error: error.message,
    });
  }
}

module.exports = {
  listarClientes,
  crearCliente,
};