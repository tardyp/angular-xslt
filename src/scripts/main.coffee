# @maybetodo find a way to generate this file automatically
# based on dependancy decoration we could put in the coffeescript's header
require
    shim:
        'controllers/xmlController'          : deps: ['app','libs/jquery.xml2json']
        'app'                                : deps: ['libs/angular', 'libs/angular-resource', 'libs/ng-grid' ]
        'libs/ng-grid'                       : deps: ['libs/angular']
        'libs/angular-resource'              : deps: ['libs/angular']
        'libs/angular'                       : deps: ['libs/jquery.min',
                                                    'libs/lodash']
        'libs/jquery.xml2json'               : deps: ['libs/jquery.min']
        'bootstrap'                          : deps: ['app']
        'routes'                             : deps: ['app']
        'run'                                : deps: ['app']
    [
        'require'
        'controllers/xmlController'
        'run'
    ], (require) ->
        require ['bootstrap']
