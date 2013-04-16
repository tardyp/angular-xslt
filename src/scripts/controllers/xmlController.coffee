angular.module('app').controller 'xmlController', ['$log', '$scope', '$http'
    ($log, $scope, $http) ->
        $scope.myData = [];
        $scope.gridOptions = { data: 'myData' };
        url = document.location+""
        console.log(url)
        if url.slice(-4) isnt ".xml"
            url = "test.xml"
        $http.get(url).success( (res) ->
                $scope.myData = $.xml2json(res).cd
            )
]