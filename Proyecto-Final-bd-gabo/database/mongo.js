const mongoose = require("mongoose");

mongoose.connect(process.env.MONGO_URI);

const db = mongoose.connection;

db.on("error", (err) => {
  console.error("Error conectando a MongoDB", err);
});

db.once("open", () => {
  console.log("MongoDB Atlas conectado");
});

module.exports = mongoose;