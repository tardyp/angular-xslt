// Generated by CoffeeScript 1.4.0

require({
  shim: {
    'controllers/xmlController': {
      deps: ['app']
    },
    'app': {
      deps: ['libs/angular', 'libs/angular-resource', 'libs/ng-grid']
    },
    'libs/ng-grid': {
      deps: ['libs/angular']
    },
    'libs/angular-resource': {
      deps: ['libs/angular']
    },
    'libs/angular': {
      deps: ['libs/jquery.min']
    },
    'bootstrap': {
      deps: ['app']
    },
    'routes': {
      deps: ['app']
    },
    'run': {
      deps: ['app']
    }
  }
}, ['require', 'controllers/xmlController', 'run'], function(require) {
  return require(['bootstrap']);
});
