angular.module('quickstart.controllers', [])

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
  $scope.delete = function (contact) {
    contacts.delete({
      id: contact.id
    }, function() {
      var letter = contact.firstName.substring(0,1).toUpperCase();
      $scope.groupedContacts[letter].splice($scope.groupedContacts[letter].indexOf(contact), 1);
      if ($scope.groupedContacts[letter].length === 0) {
        delete $scope.groupedContacts[letter];
      }
      $scope.contacts.showDelete = false;
    });
  };
})

.controller('ContactCtrl', function ($scope, $stateParams, contacts, $location) {
  if ($stateParams.id) {
    contacts.get({
      id: $stateParams.id
    }, function (contact) {
      $scope.model = contact;
    });
  }
  $scope.save = function (contact) {
    if ($stateParams.id) {
      contacts.update(contact, onSuccess);
    } else {
      contacts.save(contact, onSuccess);
    }

    function onSuccess() {
      $location.url('/app/contacts');
    }
  };
})

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
  $scope.logout = function () {
    users.logout({}, function() {
      $location.url('/app/login');
    });
  };
})

.controller('RoleCtrl', function ($scope, $location, users, roles) {
  users.query({}, function(data) {
    $scope.users = data;
  });
  roles.get(function(data) {
    $scope.roles = data;
  });
  $scope.save = function (roleAssignment) {
    roles.save(roleAssignment, function() {
      //todo
    });
  };
});