const axios = require('axios');

const API_PRODUCTOS = process.env.PRODUCTOS_API_URL || 'http://127.0.0.1:8000/productos';

exports.obtenerProductos = async () => {
  const res = await axios.get(API_PRODUCTOS);
  return res.data;
};

exports.crearProducto = async (producto) => {
  const res = await axios.post(API_PRODUCTOS, producto);
  return res.data;
};

exports.obtenerProducto = async (id) => {
  const res = await axios.get(`${API_PRODUCTOS}/${id}`);
  return res.data;
};

exports.actualizarProducto = async (id, producto) => {
  const res = await axios.put(`${API_PRODUCTOS}/${id}`, producto);
  return res.data;
};

exports.eliminarProducto = async (id) => {
  // 1. Obtener producto actual
  const productoActual = await axios.get(`${API_PRODUCTOS}/${id}`);

  // 2. Modificar activo a false
  const productoActualizado = {
    ...productoActual.data,
    activo: false
  };

  // 3. Enviar actualización en lugar de delete
  const res = await axios.put(`${API_PRODUCTOS}/${id}`, productoActualizado);

  return res.data;
};
