angular.module('food-coop').controller 'CreateUserAdminCtrl', ($scope, $stateParams, $mdToast) ->

  $scope.user = {}

  $scope.validate = (isValid) ->
    if isValid
      if $scope.user.password?
        Accounts.createUser $scope.user, (err) ->
          if err
            return $scope.error = err.message
          $scope.success()
          return
      else
        Meteor.call 'inviteUser', $scope.user, $scope.producer, (err) ->
          if err
            console.log err
            $mdToast.show $mdToast.simple().content("Oops something went wrong, is that email already registered to a user?").position('bottom left').hideDelay(4000)
            return
          else
            $scope.success("invited user to join the Co-op")
            return
    else
      $scope.submitted = true
    return

  $scope.success = (message="Created Successfully")->
    $mdToast.show $mdToast.simple().content(message).position('bottom left').hideDelay(3000)
    $scope.user = {}
    return




  return

# ---
# generated by js2coffee 2.1.0
