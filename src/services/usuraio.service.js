const axios = require('axios');

const API_USUARIOS = process.env.USUARIOS_API_URL || 'http://127.0.0.1:8000/usuarios';

exports.obtenerUsuarios = async () => {
  const res = await axios.get(API_USUARIOS);
  return res.data;
};

exports.crearUsuario = async (usuario) => {
  const res = await axios.post(API_USUARIOS, usuario);
  return res.data;
};

exports.obtenerUsuario = async (id) => {
  const res = await axios.get(`${API_USUARIOS}/${id}`);
  return res.data;
};

exports.actualizarUsuario = async (id, usuario) => {
  const res = await axios.put(`${API_USUARIOS}/${id}`, usuario);
  return res.data;
};

// 🔥 ELIMINACIÓN LÓGICA (HU7)
exports.eliminarUsuario = async (id) => {
  const usuarioActual = await axios.get(`${API_USUARIOS}/${id}`);

  const usuarioActualizado = {
    ...usuarioActual.data,
    activo: false
  };

  const res = await axios.put(`${API_USUARIOS}/${id}`, usuarioActualizado);
  return res.data;
};