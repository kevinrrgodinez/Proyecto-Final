require('dotenv').config();
const app = require('./app');
const pool = require('./config/db');

const PORT = process.env.PORT || 8010;

async function startServer() {
  try {
    await pool.connect();
    console.log('✅ Conectado a PostgreSQL');

    app.listen(PORT, () => {
      console.log(`🚀 Microservicio productos corriendo en puerto ${PORT}`);
    });
  } catch (error) {
    console.error('❌ Error conexión PostgreSQL:', error);
  }
}

startServer();