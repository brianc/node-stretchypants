# stretchypants

Sometimes I get all fat feeling and need to wear stretchypants.  At the same time I wrote the world's worst elasticsearch client :tm:.

The only thing this really does is scope your request urls to an `/<index>` and `/<type>` url, and do bulk inserts because those are neat.

### example

```js
var es = require('stretchypants')

var es = es.index('boop').type('hai')

var search = {
  query: {
    querystring: {
      name: "Berzor0rk"
    }
  }
}

es.index('boop').type('hai').get('/search', search, function(err, res) {
  if(err) {
    throw err
  }
  if(res.statusCode > 299) {
    throw new Error('Bad status ' + res.statusCode)
  }
  console.log('got some great results')
  console.log(res)
})
```

There are bulk inserts too which is really kinda the point of the library but remember how I'm so lazy I wear stretchypants?  yeah...sometimes I'm so lazy I don't document either. :no_mouth:


LICENSE

You probabaly don't want to use this, but if you do: MIT
