'use strict';
//var url = 'http://quickstarts-edewit.rhcloud.com/';
var url = 'http://localhost:8080/jboss-contacts-mobile-picketlink-secured/';
var backend = angular.module('quickstart.services', []);

backend.factory('authz', function ($http, $resource) {
  return {
    setCredentials: function (username, password) {
      var encoded = btoa(username + ':' + password);
      $http.defaults.headers.common.Authorization = 'Basic ' + encoded;
    },
    clearCredentials: function () {
      document.execCommand("ClearAuthenticationCache");
      $http.defaults.headers.common.Authorization = 'Basic ';
    }
  }
});

backend.factory('users', function ($resource) {
  return $resource(url + 'rest/security/:method/:verb', {}, {
    login: {
      method: 'GET',
      params: {
        method: 'user',
        verb: 'info'
      }
    },
    register: {
      method: 'POST',
      params: {
        method: 'registration'
      }
    },
    query: {
      method: 'GET',
      isArray: true,
      params: {
        method: 'user'
      }
    },
    logout: {
      method: 'POST',
      params: {
        method: 'logout'
      }
    }
  });
});

backend.factory('roles', function ($http) {
  return {
    get: function (callback) {
      $http.get(url + 'rest/security/role')
        .success(function (data) {
          callback(data);
        });
    },
    save: function (roleAssignment, callback) {
      $http.post(url + 'rest/security/role/assign/' + roleAssignment.userName + '/' + roleAssignment.role, {})
        .success(function () {
          callback();
        });
    }
  }
});

backend.factory('contacts', function ($resource) {
  return $resource(url + 'rest/contacts/:id', {
    id: '@id'
  }, {
    get: {
      method: 'GET'
    },
    query: {
      method: 'GET',
      isArray: true
    },
    delete: {
      method: 'DELETE'
    },
    update: {
      method: 'PUT'
    }
  });
});