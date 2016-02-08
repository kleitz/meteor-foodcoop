isAdmin = (user) ->
  Roles.userIsInRole user, 'admin'
	
isProducer = (user) ->
	Roles.userIsInRole user, 'producer'

angular.module('food-coop').config ($stateProvider) ->
  $stateProvider
  .state('store',
    url: '/store?name&certification&producer&search'
    templateUrl: 'client/products/views/products-list.ng.html'
    controllerAs: 'store'
    controller: 'ProductsPageCtrl')
  .state('store.category',
    url: '/:category?name&certification&producer&search'
    templateUrl: 'client/products/views/product-cards.ng.html'
    controller: 'ProductCardsCtrl'
    controllerAs: 'card'
  )
  .state('productDetails',
    url: '/product/:productId'
    templateUrl: 'client/products/views/product-details.ng.html'
    controller: 'ProductDetailsCtrl'
    controllerAs: 'ctrl')
  .state 'productCreate',
    url: '/new-product'
    templateUrl: 'client/products/views/product-create.ng.html'
    controller: 'ProductCreateCtrl'
    controllerAs: 'ctrl'
    resolve: 'currentUser': ($auth) ->
      $auth.requireUser()
  .state 'myProducts',
    url: '/my-products'
    templateUrl: 'client/products/views/my-products.ng.html'
    controller: 'MyProductsCtrl'
    resolve: 'currentUser': ($auth) ->
      $auth.requireUser()
  return

# ---
# generated by js2coffee 2.1.0