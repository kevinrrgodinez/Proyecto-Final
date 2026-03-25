const path = require("path");

// 🔥 FORZAR RUTA ABSOLUTA
require("dotenv").config({
  path: path.resolve(__dirname, "../.env"),
});

console.log("MONGO_URI:", process.env.MONGO_URI); // 👈 prueba

const app = require("./app");

// conectar bases
require("../database/mongo");
require("../database/postgres");

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en puerto ${PORT}`);
});