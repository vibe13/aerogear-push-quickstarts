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
    }
  });
});

backend.factory('contacts', function ($resource) {
  return $resource(url + 'rest/contacts/', {}, {
    get: {
      method: 'GET',
      isArray: true
    }
  });
});