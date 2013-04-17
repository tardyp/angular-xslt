angular.module('app').controller 'xmlController', ['$log', '$scope', '$http'
    ($log, $scope, $http) ->
        typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'
        buildCellTemplate = (map) ->
            l = []
            for k,v of map
                l.push("'#{k}': row.getProperty(col.field)==='#{v}'")

            class_spec = l.join(",")
            console.log class_spec
            return "<div ng-class=\"{#{class_spec}}\">{{row.getProperty(col.field)}}</div>"
        $scope.myData = []
        $scope.gridOptions =
            data: 'myData'
            columnDefs: "columnDefs"
            showGroupPanel: true
            enableCellEdit:true
            showFilter:true
            showFooter:true
            showSelectionCheckbox:true
            enableCellSelection:true
            enableColumnResize:true
            showColumnMenu:true
        $scope.columnDefs =
            [
                {
                    field: 'groups',
                    displayName:'Groups'
                },
                {
                    field: 'name',
                    displayName:'Git repository'
                },
                {
                    field: 'path',
                    displayName:'Repo path'
                },
                {
                    field: 'revision',
                    displayName:'Revision'
                },
            ]
        url = document.location+""
        console.log(url)
        if url.slice(-4) isnt ".xml"
            url = "test.xml"
        $http.get(url).success( (res) ->
                data = $.xml2json(res)
                annotations = {}
                for project in data.project
                    project.groups = project.groups.split(",")
                    newgroup = []
                    newgroup.push(g) for g in project.groups when (g.indexOf("name:") isnt 0 && g.indexOf("path:") isnt 0)
                    project.groups = newgroup.join(", ")
                    if typeIsArray(project.annotation)
                        annotations[a.name] = 1 for a in project.annotation

                for project in data.project
                    for name,v of annotations
                        project[name] = "n/a"
                    if typeIsArray(project.annotation)
                        project[a.name] = a.value for a in project.annotation
                for name,v of annotations
                    $scope.columnDefs.push(
                        field:name
                        width:50
                        displayName:name
                        cellTemplate:buildCellTemplate {
                           '':'n/a',
                           'btn btn-success':'src',
                           'btn btn-warning':'bin',
                           'btn btn-inverse':'no',
                            }
                        )
                $scope.myData = data.project
            )
]
