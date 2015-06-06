angular.module('roos.services', [])
.factory('lockerdome', function($http){
    var fac = {};
    var siteurl = "http://api.globalhack4.test.lockerdome.com/";
            
    fac.get = function() {
        var request = siteurl + "app_create_content?";
        return $http({
            url: request, 
            method: "GET",
            data: {"app_id":7740739530260546,
                "app_secret":"ycJgreLAX4Q0jTr6A1gcszO/7rWUxPU+UysAlwec+V6+VX5gZZLwHdrmF3vE0fWmLrBrCJJ9Wt7zdPj8Zh+Lyg==",
                "app_data":{
                    "fun":"times"
                },
                "name":"Some App Content",
                "text":"Short description of your content"
            }
         });
    };
    var siteurl2 = "http://rootastic.us.to/1.0.0/content_id";
            
    fac.get2 = function() {
        var request = siteurl2 + "?";
        return $http({
            url: request, 
            method: "GET",
            data: {"test":true
            }
         });
    };
    return fac;
});