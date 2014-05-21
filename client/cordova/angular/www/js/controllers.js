angular.module('quickstart.controllers', [])

.controller('AppCtrl', function($scope) {
})

.controller('ContactsCtrl', function($scope, contacts) {
  contacts.get({}, function(data) {
    $scope.contacts = data;
  });
})

.controller('PlaylistCtrl', function($scope, $stateParams) {
})

.controller('LoginCtrl', function($scope, $location, authz, users) {
  $scope.login = function(user) {
    authz.setCredentials(user.name, user.password);
    users.login({}, function() {
      $location.url('/app/contacts');
    });
  };
  $scope.signup = function(data) {
    users.register(data, function() {
      $location.url('/app/login');
    });
  };
})
