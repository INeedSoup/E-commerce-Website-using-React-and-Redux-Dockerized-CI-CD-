import axios from "axios";

// read from .env or fall back to fakestoreapi.com
const BASE_URL = process.env.REACT_APP_API_URL || "https://fakestoreapi.com";

export const callAPI = async (method, endpoint, data = null) => {
  const config = {
    url: `${BASE_URL}${endpoint}`,
    method,
    data,
  };

  return new Promise((resolve, reject) => {
    axios(config)
      .then((response) => {
        resolve(response.data);
      })
      .catch((err) => {
        reject(err.response);
      });
  });
};
