const routes = (handler) => [
  /**
 * @TODO 1
 * Define route for POST method
 */
  {
    method: 'GET',
    path: '/health',
    handler: (request, h) => {
      return h.response({ status: 'OK', timestamp: new Date().toISOString() }).code(200);
    },
  },
  {
    method: 'POST',
    path: '/products',
    handler: handler.addProductHandler,
  },
  {
    method: 'GET',
    path: '/products',
    handler: handler.getAllProductsHandler,
  },
  {
    method: 'GET',
    path: '/products/{id}',
    handler: handler.getOneProductHandler,
  }
];

module.exports = routes;