const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");

let usuarios = [
  {
    id: 1,
    nombre: "Admin",
    correo: "admin@test.com",
    password: "$2b$10$Z7T1NFTVCw4GboNTKGrCL.4NTFwJVqAVCq1gT5KZnB.FI392mXrU2",
    rol: "ADMIN"
  }
];

exports.login = async (req, res) => {
  try {
    const { correo, password } = req.body;

    // buscar usuario
    const user = usuarios.find(u => u.correo === correo);

    if (!user) {
      return res.status(401).json({ msg: "Credenciales inválidas" });
    }

    // validar password
    const passwordValido = await bcrypt.compare(password, user.password);

    if (!passwordValido) {
      return res.status(401).json({ msg: "Credenciales inválidas" });
    }

    // generar token
    const token = jwt.sign(
      {
        id: user.id,
        rol: user.rol
      },
      process.env.JWT_SECRET,
      { expiresIn: "8h" }
    );

    res.json({
      token,
      usuario: {
        id: user.id,
        nombre: user.nombre,
        rol: user.rol
      }
    });

  } catch (error) {
    res.status(500).json({ msg: "Error en login" });
  }
};