// If you add things to the package.json in this directory, you can magically require them here
// Netlify takes care of all the things
// const axios = require("axios");

exports.handler = function(event, context, callback) {
  // Get some env var values defined in our Netlify site UI
  const { API_TOKEN, API_URL } = process.env;
  
  // You can log some stuff here to aid  debugging
  // console.log("Injecting token to", API_URL);

  return callback(null, {
    statusCode: 200,
    headers: { 
      "content-type": "application/json; charset=UTF-8",
      "access-control-allow-origin": "*",
      "access-control-expose-headers": "content-encoding,date,server,content-length"
    },
    body: JSON.stringify({
      "api-token": API_TOKEN,
      "api-url": API_URL
    })
  })
}