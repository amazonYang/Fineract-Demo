define(['underscore'], function () {
    var styles = {
        css: [
            'bootstrap.min.c33e9a22.css',
            'bootstrap-ext.1b033753.css',
            'bootswatch.ef900d9b.css',
            'font-awesome.min.css',
            'app.03654507.css',
            'nv.d3.5b694215.css',
            'style.0f31ea67.css',
            'chosen.min.a355d0a0.css'
        ]
    };

    require(_.reduce(_.keys(styles), function (list, pluginName) {
        return list.concat(_.map(styles[pluginName], function (stylename) {
            return pluginName + '!styles/' + stylename;
        }));
    }, []));
});
