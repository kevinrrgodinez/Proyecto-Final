const axios = require("axios");

const API_PRODUCTOS = "http://127.0.0.1:8000/productos";

// Obtener productos
exports.obtenerProductos = async () => {
  const res = await axios.get(API_PRODUCTOS);
  return res.data;
};

// Crear producto
exports.crearProducto = async (producto) => {
  const res = await axios.post(API_PRODUCTOS, producto);
  return res.data;
};

// Obtener producto por id
exports.obtenerProducto = async (id) => {
  const res = await axios.get(`${API_PRODUCTOS}/${id}`);
  return res.data;
};

// Actualizar producto
exports.actualizarProducto = async (id, producto) => {
  const res = await axios.put(`${API_PRODUCTOS}/${id}`, producto);
  return res.data;
};

// Eliminar producto
exports.eliminarProducto = async (id) => {
  const res = await axios.delete(`${API_PRODUCTOS}/${id}`);
  return res.data;
};