http = require "http"
concat = require "concat-stream"
ok = require "okay"
async = require "async"
config = require "../lib/config"

module.exports = class ES

  @index: (name) -> new ES(name)

  constructor: (name) ->
    @basePath = ""
    if name?
      @basePath = "/#{@basePath}#{name}"
      @indexName = name

  type: (name) ->
    result = new ES(@indexName)
    result.typeName = name
    result.basePath = "#{result.basePath}/#{name}"
    return result

  request: (options, cb) ->
    options.hostname = config.es.host
    options.port = config.es.port
    if options.path.indexOf('?') > -1
      options.path += "&case=camelCase"
    else
      options.path += "?case=camelCase"

    if config.es.username?
      {username, password} = config.es
      encoded = new Buffer("#{username}:#{password}").toString('base64')
      options.headers =
        "Authorization": "Basic #{encoded}"

    options.path = "#{@basePath}#{options.path}" if @basePath?

    req = http.request options, (res) ->
      if not res or res.statusCode > 299
        console.log res.body
        return cb(new Error "bad status code #{res and res.statusCode}")
      res.setEncoding "utf8"
      res.pipe concat (data) ->
        #console.log data
        cb null, JSON.parse(data)

    console.log options.method, "http://#{options.hostname}:#{options.port}#{options.path}"
    if options.data?
      if typeof options.data is "string"
        req.write options.data
      else
        body = JSON.stringify(options.data)
        #console.log body
        req.write body
    req.end()
    req.once 'error', cb

  dispatch: (method, path, data, cb) ->
    if typeof data is "function"
      cb = data
      data = null

    @request {method, path, data}, cb

  get: (path, body, cb) ->
    @dispatch "GET", path, body, cb

  post: (path, body, cb) ->
    @dispatch "POST", path, body, cb

  delete: (path, body, cb) ->
    @dispatch "DELETE", path, body, cb

  put: (path, body, cb) ->
    @dispatch "PUT", path, body, cb

  @ok: (cb) ->
    (err, res) ->
      throw err if err?
      throw new Error(JSON.stringify(res)) unless res.ok is true
      cb(res)

  bulk: (action, fields) ->
    Bulk = require "./es-bulk"
    new Bulk this

  # helper to perform simple query string search
  query: (field, searchString, cb) ->
    search =
      query:
        bool:
          should: [{ prefix: {} }, { match: {} }]

    search.query.bool.should[0].prefix[field] =
      prefix: searchString
      boost: 1.0

    search.query.bool.should[1].match[field] =
      query: searchString
      operator: "and"

    @post "/_search", search, cb
