require('dotenv').config();
const app = require('./app');
const connectMongo = require('./config/mongo');

const PORT = process.env.PORT || 3000;

async function startServer() {
  await connectMongo();

  app.listen(PORT, () => {
    console.log(`Backend general corriendo en http://127.0.0.1:${PORT}`);
  });
}

startServer();