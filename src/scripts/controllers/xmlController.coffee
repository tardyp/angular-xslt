angular.module('app').controller 'xmlController', ['$log', '$scope', '$http'
    ($log, $scope, $http) ->

        # helper function for preparing the cell template
        buildCellTemplate = (map) ->
            l = []
            for k,v of map
                l.push("'#{k}': row.getProperty(col.field)==='#{v}'")

            class_spec = l.join(",")
            return "<div ng-class=\"{#{class_spec}}\">{{row.getProperty(col.field)}}</div>"

        $scope.myData = []

        # enable every thing in ngGrid
        $scope.gridOptions =
            data: 'myData'
            columnDefs: "columnDefs" # if columnDefs is a string, ngGrid will get it from the $scope *and listen to changes*
            showGroupPanel: true
            enableCellEdit:true
            showFilter:true
            showFooter:true
            showSelectionCheckbox:true
            enableCellSelection:true
            enableColumnResize:true
            showColumnMenu:true

        # base columnDefs
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
        # if the document location is ending with xml, we are using the app
        # in xslt mode. If not, we are just in dev mode, so we load
        # a default "test.xml" xml, instead of reloading the xml
        # reloading the xml is harmless as it is already in cache
        # there is no other way to get the xml from javascript, because the xslt has
        # already been parsed
        if url.slice(-4) isnt ".xml"
            url = "test.xml"
        $http.get(url).success( (res) ->
                data = $.xml2json(res)
                annotations = {}
                # first pass where we get the list of annotations name
                # and remove the useless default groups
                for project in data.project
                    project.groups = project.groups.split(",")
                    newgroup = []
                    newgroup.push(g) for g in project.groups when (g.indexOf("name:") isnt 0 && g.indexOf("path:") isnt 0)
                    project.groups = newgroup.join(", ")

                    # if there is only one annotation, xml2json dont put it in an array :-(
                    if _.isObject(project.annotation)
                        project.annotation = [project.annotation]
                    if _.isArray(project.annotation)
                        annotations[a.name] = 1 for a in project.annotation

                # second pass, we put default annotation
                # and populate the from real annotations
                for project in data.project
                    for name,v of annotations
                        project[name] = "n/a"
                    if _.isArray(project.annotation)
                        project[a.name] = a.value for a in project.annotation

                # build the annotation columnDefs
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
