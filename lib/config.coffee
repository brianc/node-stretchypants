module.exports =
  es:
    host: process.env.ES_HOST
    port: parseInt(process.env.ES_PORT)
    username: process.env.ES_USERNAME
    password: process.env.ES_PASSWORD
