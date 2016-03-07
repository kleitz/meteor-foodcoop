angular.module('food-coop').controller 'pageCtrl', ($scope, $reactive, $stateParams, uiGmapGoogleMapApi, $mdToast, $window, $timeout) ->
  $reactive(this).attach($scope)
  vm = this;
  
  vm.subscribe 'producer', -> [$stateParams.producerId]

  vm.helpers
    likesCount: ->
      Likes.find(likee: $stateParams.producerId)
    producer: ->
      Meteor.users.findOne $stateParams.producerId
    products: ->
      producer = Meteor.users.findOne($stateParams.producerId)
      if producer?
        Products.find
          producer: producer._id
          published: true
        ,
          sort: name:1
          limit: 4
        
  vm.autorun ->
    vm.isOwner = Meteor.userId()? and Meteor.userId() == $stateParams.producerId
  
  vm.autorun ->
    if Meteor.user()
      list = Meteor.user().profile.lovedProducers or []
      if Meteor.users.findOne($stateParams.producerId._id) in list
        vm.lovesProducer = true
      else
        vm.lovesProducer = false
  
  vm.toggleLike = ->
    unless Meteor.userId()?
      $mdToast.show $mdToast.simple().content("Please login to endorse this producer").position('bottom left').hideDelay(4000)
      return
    like = Likes.findOne(liker: Meteor.userId(), likee: vm.producer._id)
    if like?
      Likes.remove(like._id)
      $mdToast.show $mdToast.simple().content("Removed your endorsement").position('bottom left').hideDelay(4000)
    else
      Meteor.call "/likes/add", vm.producer._id, 'user', (err, response) ->
        if (err)
          console.log(err)
          $mdToast.show $mdToast.simple().content("Clap clap! Thanks for your endorsement!").position('bottom left').hideDelay(4000)
        
  vm.likesProducer = (producerId) ->
    if Likes.findOne(liker: Meteor.userId(), likee: producerId) then return 'liked' else return 'not-liked'
  
  # vm.toggleLove = ->
  #   unless Meteor.userId()?
  #     $mdToast.show $mdToast.simple().content("Please login to endorse this producer").position('bottom left').hideDelay(4000)
  #     return
  #
  #   unless vm.producer.profile.loveCount?
  #     Meteor.users.update vm.producer._id, $set: 'profile.loveCount' : 0
  #
  #   list = Meteor.user().profile.lovedProducers or []
  #   if vm.producer._id in list
  #     Meteor.users.update vm.producer._id, $inc: 'profile.loveCount' : -1
  #     Meteor.users.update Meteor.userId(), $pull: 'profile.lovedProducers': vm.producer._id
  #
  #     $mdToast.show $mdToast.simple().content("Your endorsement has been removed").position('bottom left').hideDelay(4000)
  #   else
  #     Meteor.users.update vm.producer._id, $inc: 'profile.loveCount' : 1
  #     Meteor.users.update Meteor.userId(), $push: 'profile.lovedProducers': vm.producer._id
  #
  #     $mdToast.show $mdToast.simple().content("Clap clap! Thanks for your endorsement!").position('bottom left').hideDelay(4000)

  vm.mapSettings =
    center: {latitude:-35.7251117, longitude: 174.323708}
    zoom: 10
    options: scrollwheel: false
    events: tilesloaded: (map) ->
      uiGmapGoogleMapApi.then (maps) ->
        service = new maps.places.PlacesService(map)
        service.getDetails
          placeId: vm.producer.profile.deliveryAddress.place_id
        , (result, status) ->
          $scope.$apply ->

            vm.mapSettings.center =
              latitude: result.geometry.location.lat()
              longitude: result.geometry.location.lng()

            vm.markerSettings =
              id: $stateParams.producerId
              coords:
                latitude: result.geometry.location.lat()
                longitude: result.geometry.location.lng()
              options: {}
            return
          return
        return


  vm.markup = Meteor.settings.public.markup / 100 + 1;
  
  vm.modelOptions = updateOn: 'default blur', debounce: { default: 200, blur: 0 }
  
  _timer = null
  
  vm.save = (profile, data) ->
    Meteor.users.update Meteor.userId(),
      $set: profile: profile
    , (err, result) ->
      if err
        console.error err
        return $mdToast.show $mdToast.simple().content("Connection Error: Failed to Save").position('bottom left').hideDelay(4000)
    return  
      
  
  return vm;

# ---
# generated by js2coffee 2.1.0
