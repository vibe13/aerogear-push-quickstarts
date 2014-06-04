/*
 * JBoss, Home of Professional Open Source
 * Copyright Red Hat, Inc., and individual contributors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * 	http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
'use strict';

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
    
    var pushConfig = {
      pushServerURL: "<pushServerURL e.g http(s)//host:port/context >",
      android: {
        senderID: "<senderID e.g Google Project ID only for android>",
        variantID: "<variantID e.g. 1234456-234320>",
        variantSecret: "<variantSecret e.g. 1234456-234320>"
      },
      ios: {
        variantID: "<variantID e.g. 1234456-234320>",
        variantSecret: "<variantSecret e.g. 1234456-234320>"
    }
    };

    //to be able to test this in your browser where there is no push plugin installed
    if (typeof push !== "undefined") {
      push.register(onNotification, successHandler, errorHandler, pushConfig);
    }

    function successHandler() {
      console.log('successful registered');
    }

    function errorHandler(error) {
      console.log('error registering ' + error);
    }

    function onNotification(event) {
      angular.element(document.getElementById('root')).scope().$broadcast('notification', event);
    }
  });
})
.constant('BACKEND_URL','< backend URL e.g http(s)//host:port >/jboss-contacts-mobile-picketlink-secured/')

.config(function ($stateProvider, $urlRouterProvider, $httpProvider) {
  $stateProvider

  .state('app', {
    url: "/app",
    abstract: true,
    templateUrl: "templates/menu.html",
    controller: 'LoginCtrl'
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

  .state('app.contact', {
    url: "/contact/:id",
    views: {
      'menuContent': {
        templateUrl: "templates/contact.html",
        controller: 'ContactCtrl'
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
    };
  };
  $httpProvider.defaults.withCredentials = true;
  $httpProvider.responseInterceptors.push(interceptor);
});
