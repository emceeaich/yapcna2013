var Router;
var app = {};
app.views = {};

Router = Backbone.Router.extend({
    routes: {
	'' : 'main',
        'item/:id' : 'detail'
    },

    main: function() {
	console.log('main');
        if (_.isUndefined(app.views.main)) {
	    app.views.main = new Main({
               el: '#content'
            });
        }
	else {
            app.views.main.render();
        }
    },

    detail: function(id) {
	console.log('detail');
        if (_.isUndefined(app.views[id])) {
	    app.views[id] = new Detail({
                el: '#content',
                id: id
            });
        }
        else  {
	    app.views[id].render();
        }
    } 
});

Main = Backbone.View.extend({
    initialize: function() {
        var Collection = Backbone.Collection.extend({
            url: '/api',
            parse: function(data) {
                return data.collection; 
            }
        });
        this.collection = new Collection();
        this.collection.on('sync', this.render, this);
        this.collection.fetch();
    },
    render: function() {
	this.$el.html('');
        this.collection.each(function(model) {
             this.$el.append(Mustache.render('<p><a href="#item/{{id}}">{{title}}</a></p>', model.toJSON()));
        }, this);
	return this;
    }
});

Detail = Backbone.View.extend({
    initialize: function(options) {
        var Model = Backbone.Model.extend({
            url: '/api/' + options.id
        });
        this.model = new Model();
        this.model.on('change', this.render, this);
	this.model.fetch();
    },
    render: function() {
	this.$el.html('');
        this.$el.append(Mustache.render('<p>Details about {{title}}</p><p><a href="#">Back</a></p>', this.model.toJSON()));
	return this;
    }
});

app.router = new Router();
Backbone.history.start();

