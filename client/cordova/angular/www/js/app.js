// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
// 'starter.controllers' is found in controllers.js
angular.module('quickstart', [
  'ionic',
  'quickstart.controllers',
  'quickstart.services',
  'ngResource'
])

.run(function ($ionicPlatform) {
  $ionicPlatform.ready(function () {
    // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    // for form inputs)
    if (window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
    }
    if (window.StatusBar) {
      // org.apache.cordova.statusbar required
      StatusBar.styleDefault();
    }
  });
})

.config(function ($stateProvider, $urlRouterProvider, $httpProvider) {
  $stateProvider

  .state('app', {
    url: "/app",
    abstract: true,
    templateUrl: "templates/menu.html",
    controller: 'AppCtrl'
  })

  .state('app.login', {
    url: "/login",
    views: {
      'menuContent': {
        templateUrl: 'templates/login.html',
        controller: 'LoginCtrl'
      }
    }
  })

  .state('app.signup', {
    url: "/signup",
    views: {
      'menuContent': {
        templateUrl: 'templates/signup.html',
        controller: 'LoginCtrl'
      }
    }
  })
  
  .state('app.contact', {
    url: "/contact/:id",
    views: {
      'menuContent': {
        templateUrl: "templates/contact.html",
        controller: 'ContactCtrl'
      }
    }
  })

  .state('app.role-assignment', {
    url: "/role-assignment",
    views: {
      'menuContent': {
        templateUrl: "templates/role-assignment.html",
        controller: 'RoleCtrl'
      }
    }
  })
    .state('app.contacts', {
      url: "/contacts",
      views: {
        'menuContent': {
          templateUrl: "templates/contacts.html",
          controller: 'ContactsCtrl'
        }
      }
    })

  .state('app.about', {
    url: "/about",
    views: {
      'menuContent': {
        templateUrl: "templates/about.html"
      }
    }
  });
  // if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise('/app/contacts');

  var interceptor = function ($q, $location) {
      function success(response) {
        return response;
      }

      function error(response) {
        var status = response.status;
        if (status === 401) {
          $location.url("/app/login");
          return;
        }
        // otherwise
        return $q.reject(response);
      }
      return function (promise) {
        return promise.then(success, error);
      }
    };
  $httpProvider.defaults.withCredentials = true;
  $httpProvider.responseInterceptors.push(interceptor);
});