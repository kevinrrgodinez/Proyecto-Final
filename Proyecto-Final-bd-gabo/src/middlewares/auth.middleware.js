const jwt = require("jsonwebtoken");

exports.verificarToken = (req, res, next) => {
  try {
    console.log("AUTH HEADER:", req.headers.authorization);
    const token = req.headers.authorization?.split(" ")[1];

    if (!token) {
      return res.status(401).json({ msg: "Token requerido" });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;

    next();
  } catch (error) {
    res.status(401).json({ msg: "Token inválido" });
  }
};

// middleware de roles
exports.verificarRol = (...rolesPermitidos) => {
  return (req, res, next) => {
    if (!rolesPermitidos.includes(req.user.rol)) {
      return res.status(403).json({ msg: "Sin permisos" });
    }
    next();
  };
};