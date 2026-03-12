const axios = require("axios");

const obtenerTipoCambio = async () => {

  try {

    const response = await axios.get(
      "https://api.exchangerate-api.com/v4/latest/USD"
    );

    return response.data.rates;

  } catch (error) {
    console.error("Error obteniendo divisas");
    return null;
  }

};

module.exports = {
  obtenerTipoCambio
};