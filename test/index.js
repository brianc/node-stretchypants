var es = require('../')
var ok = require('okay')
var assert = require('assert')

describe('writable stream', function() {
  it('writes', function(done) {
    var indexName = 'blah' + Date.now()
    var typeDef = {
      settings: {
        number_of_shards: 1,
      },
      mappings: {
        blah: {
          properties: {
            name: {
              type: 'string'
            }
          }
        }
      }
    }

    es.index(indexName).post('/', typeDef, ok(function() {

      var client = es.index(indexName).type('blah')
      var records = [{
        name: 'Brian'
      }, {
        name: 'Aaron'
      }];
      client.write(records, ok(function() {
        setTimeout(function() {
          es.index(indexName).get('/_stats', ok(function(res) {
            assert.equal(res.All.primaries.docs.count, 2)
            done()
          }))
        }, 1000)
      }))
    }))
  })
})
