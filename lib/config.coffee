module.exports =
  es:
    host: process.env.ES_HOST || 'localhost'
    port: parseInt(process.env.ES_PORT) || 9200
    username: process.env.ES_USERNAME
    password: process.env.ES_PASSWORD
  web:
    port: process.env.PORT || 3333

if process.env.BONSAI_URL?
  url = require "url"
  parts = url.parse process.env.BONSAI_URL
  es = module.exports.es
  if parts.auth
    [user, pass] = parts.auth.split ":"
    es.username = user
    es.password = pass
  es.host = parts.host.split(':')[0]
  es.port = parts.port || 80
