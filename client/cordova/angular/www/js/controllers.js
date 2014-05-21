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
    users.login();
    $location.url('/app/contacts');
  };
  $scope.signup = function(data) {
    users.register(data);
    $location.url('/app/contacts');
  };
})
