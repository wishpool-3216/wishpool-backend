'use strict';

app.config(function($stateProvider){
	$stateProvider.state('landing', {
		url: '/',
		templateUrl: 'app/views/landing.html',
		controller: 'placeholderCtrl'
	});

	$stateProvider.state('profile', {
		url: '/user/:userId',
		templateUrl: 'app/views/profile.html',
		controller: 'placeholderCtrl'
	})

})