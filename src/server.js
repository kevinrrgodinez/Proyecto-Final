require('dotenv').config();
const app = require('./app');
const connectMongo = require('./config/mongo');

const PORT = process.env.PORT || 3000;

async function startServer() {
  await connectMongo();

  app.listen(PORT, '0.0.0.0', () => {
  console.log(`Backend corriendo en puerto ${PORT}`);
});
}

startServer();