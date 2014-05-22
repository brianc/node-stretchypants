class Keys
  constructor: (@_index, @_type, @_id) ->

class Op
  constructor: (_index, _type, _id) ->
    @index = new Keys(_index, _type, _id)

module.exports = class Bulk
  constructor: (@es) ->
    @ops = []

  # add an index command to this bulk operation
  index: (doc) ->
    @ops.push new Op(@es.indexName, @es.typeName, doc.id)

    @ops.push doc

    return this

  # returns proper new-line separated JSON
  # for request to elastic search
  toJSON: ->
    result = @ops.map(JSON.stringify).join "\n"
    return "#{result}\n"

  # post the bulk request to elastic search
  post: (cb) ->
    @es.post "/_bulk", @toJSON(), cb
