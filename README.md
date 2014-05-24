# stretchypants

Sometimes I get all fat feeling and need to wear stretchypants.  Sometimes I write bad code.  This is both of those times.

The only thing this really does is scope your request urls to an `/<index>` and `/<type>` url, and do bulk inserts because those are neat.  

The most important thing is stretchypants returns you an instance of a __writable stream__ to your elasticsearch index & type.  You can pipe a (object) stream of arrays into stretchypants, and get some awesome ETL hotness like this:


### awesomeness
```
var query = require('pg-readable')
var clumpy = require('clumpy')
var es = require('stretchypants').index('your_index').type('your_type')

//ready for this? Let's pipe our entire
//table into elastic search, using bulk posts
//to our /your_index/your_type of 1000 item chunks
query('SELECT * FROM some_big_table')
  .pipe(clumpy(1000))
  .pipe(es)
  
//THAT JUST HAPPENED!!!!
```


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


LICENSE

The MIT License (MIT)

Copyright (c) 2014 Brian M. Carlson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
