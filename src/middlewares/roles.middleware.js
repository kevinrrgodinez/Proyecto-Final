function soloAdmin(req, res, next) {
  if (!req.user || req.user.rol !== 'ADMIN') {
    return res.status(403).json({
      detail: 'Acceso denegado: solo administradores',
    });
  }

  next();
}

module.exports = {
  soloAdmin,
};