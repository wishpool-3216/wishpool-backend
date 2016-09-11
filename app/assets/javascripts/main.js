'use strict';

var app = angular.module('wishpoolApp', ['ui.router', 'ngMaterial', 'mwl.bluebird'])

app.config(function ($urlRouterProvider, $mdThemingProvider) {
    $urlRouterProvider.when('','/');
    // Returns to landing page if user types an undefined url
		$urlRouterProvider.otherwise('/');
    $mdThemingProvider.theme('default')
})


/*// For Google Analytics, update tracker when state changes occur
.run(['$rootScope', '$location', '$window', function($rootScope, $location){
    $rootScope.$on('$stateChangeSuccess', function(){
      ga('send', 'pageview', { page: $location.path() });
    });
}]);
*/
