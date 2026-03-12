const { Pool } = require("pg");

const pool = new Pool({
  host: "localhost",
  user: "postgres",
  password: "12345",
  database: "ferreteria_db",
  port: 5432
});

pool.connect()
  .then(() => console.log("PostgreSQL conectado"))
  .catch(err => console.error("Error conectando a PostgreSQL:", err));

module.exports = pool;