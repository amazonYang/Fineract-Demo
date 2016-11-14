define(['Q', 'underscore', 'mifosX'], function (Q) {
    var components = {
        models: [
            'models.bf2a36f7'
        ],
        services: [
            'ResourceFactoryProvider',
            'HttpServiceProvider',
            'AuthenticationService',
            'SessionManager',
            'Paginator',
            'UIConfigService'
        ],
        controllers: [
            'controllers.277179b7'
        ],
        filters: [
            'filters.9206d4d0'
        ],
        directives: [
            'directives.1c1f5ec7'
        ]
    };

    return function() {
        var defer = Q.defer();
        require(_.reduce(_.keys(components), function (list, group) {
            return list.concat(_.map(components[group], function (name) {
                return group + "/" + name;
            }));
        }, [
            'routes-initialTasks-webstorage-configuration.6579d3de'
        ]), function(){
            defer.resolve();
        });
        return defer.promise;
    }
});
