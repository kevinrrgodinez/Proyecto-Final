const Producto = require('../models/producto.model');

// HU1: Crear producto
exports.crearProducto = async (req, res) => {
    try {
        const nuevoProducto = new Producto(req.body);
        await nuevoProducto.save();

        res.status(201).json({
            msg: "Producto registrado exitosamente",
            producto: nuevoProducto
        });
    } catch (error) {
        res.status(400).json({
            msg: "Error al registrar producto",
            error
        });
    }
};

// HU1: Actualizar producto
exports.actualizarProducto = async (req, res) => {
    try {
        const producto = await Producto.findByIdAndUpdate(
            req.params.id,
            req.body,
            { new: true }
        );

        res.json({
            msg: "Producto actualizado",
            producto
        });
    } catch (error) {
        res.status(400).json({
            msg: "Error al actualizar producto"
        });
    }
};

// HU2: Desactivar producto
exports.desactivarProducto = async (req, res) => {
    try {
        const producto = await Producto.findByIdAndUpdate(
            req.params.id,
            { activo: false },
            { new: true }
        );

        res.json({
            msg: "Producto desactivado",
            producto
        });
    } catch (error) {
        res.status(500).json({
            msg: "Error al desactivar producto"
        });
    }
};

// 🔹 Listar productos (solo activos)
exports.listarProductos = async (req, res) => {
    try {
        const productos = await Producto.find({ activo: true });
        res.json(productos);
    } catch (error) {
        res.status(500).json({
            msg: "Error al listar productos"
        });
    }
};

// HU4: Productos con stock bajo
exports.obtenerStockBajo = async (req, res) => {
    try {
        const productos = await Producto.find({
            stock: { $lte: 5 },
            activo: true
        });

        res.json(productos);
    } catch (error) {
        res.status(500).json({
            msg: "Error al consultar stock"
        });
    }
};