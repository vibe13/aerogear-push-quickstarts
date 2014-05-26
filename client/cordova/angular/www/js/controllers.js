angular.module('quickstart.controllers', [])

.controller('AppCtrl', function ($scope) {})

.controller('ContactsCtrl', function ($scope, contacts) {
  contacts.query({}, function (data) {
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
  $scope.delete = function(contact) {
    contacts.delete({id: contact.id});
  };
})

.controller('ContactCtrl', function ($scope, $stateParams, contacts, $location) {
  if($stateParams.id) {
    contacts.get({id: $stateParams.id}, function(contact) {
      $scope.model = contact;
    });
  }
  $scope.save = function(contact) {
    contacts.save(contact, function() {
      $location.url('/app/contacts');
    });
  };
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