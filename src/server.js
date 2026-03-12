require("dotenv").config();

const app = require("./app");

// conectar bases
require("../database/mongo");
require("../database/postgres");

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en puerto ${PORT}`);
});