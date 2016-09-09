'use strict';

app.controller('placeholderCtrl', function($scope, $stateParams, $mdSidenav){
	
	$scope.userId = stateParams.userId; 
	$scope.users = [];

	$scope.toggleSidenav = function () {
		$mdSidenav('sidenav').toggle();
	}


})