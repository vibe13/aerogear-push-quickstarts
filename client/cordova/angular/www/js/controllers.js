angular.module('quickstart.controllers', [])

.controller('AppCtrl', function ($scope) {})

.controller('ContactsCtrl', function ($scope, contacts) {
  contacts.get({}, function (data) {
    var first,
      length = data.length;
    $scope.groupedContacts = {};

    for (var i = 0; i < length; i++) {
      first = data[i].firstName.substring(0, 1).toUpperCase();
      if (!$scope.groupedContacts[first]) {
        $scope.groupedContacts[first] = [];
      }

      $scope.groupedContacts[first].push(data[i]);
    }
  });
})

.controller('PlaylistCtrl', function ($scope, $stateParams) {})

.controller('LoginCtrl', function ($scope, $location, authz, users) {
  $scope.login = function (user) {
    authz.setCredentials(user.name, user.password);
    users.login({}, function () {
      $location.url('/app/contacts');
    });
  };
  $scope.signup = function (data) {
    users.register(data, function () {
      $location.url('/app/login');
    });
  };
})