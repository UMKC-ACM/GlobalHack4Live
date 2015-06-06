var app = angular.module("roos", ['roos.services'])

.controller('mainCtrl', function($scope, lockerdome) {
    $scope.thus = "pie";
    
    lockerdome.get().success(successful).
          error(function(data, status, headers, config) {
                console.log("ouch");
          });
    function successful(data, status, headers, config) {
        console.log(data);
    }
});