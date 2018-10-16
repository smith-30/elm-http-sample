// save as agreed.js
module.exports = [
  {
    request: {
      path: '/user/:id',
      method: 'GET',
      query: {
        q: '{:someQueryStrings}',
      },
      values: {
        id: 'yosuke',
        someQueryStrings: 'foo'
      },
    },
    response: {
      headers: {
        'Access-Control-Allow-Origin': '*',
      },
      body: {
        message: '{:greeting} {:id} {:someQueryStrings}',
        images: '{:images}',
        themes: '{:themes}',
      },
      values: {
        greeting: 'hello',
        images: [
          'http://example.com/foo.jpg',
          'http://example.com/bar.jpg',
        ],
        themes: {
          name: 'green',
        },
      }
    },
  },
  {
    request: {
      path: '/',
      method: 'GET',
    },
    response: {
      headers: {
        'Access-Control-Allow-Origin': '*',
      },
      body: {
        message: '{:greeting}',
        themes: '{:themes}',
      },
      values: {
        greeting: 'hello',
        themes: 'green'
      }
    },
  },
]
