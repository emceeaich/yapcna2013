/* 
 * Define an anonymous, self-executing function that will set up our router and handlers
 * It will export, via window, an object from which we can access our running application
 */
(function(window) {
  var Router;

  // export the application so we can access it from the console
  window.app = {};

  // containers for views
  app.views = {};
  app.views.detail = {};

  Router = Backbone.Router.extend({

    // define two routes, one for the main page
    // another for the detail view

    routes: {
      '' : 'main',
      'item/:id' : 'detail'
    },

    // the main view checks to see if there is a pre-existing
    // main view, and it not, creates and renders it, otherwise
    // renders the main view
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

    // the detail view checks the app.views.detail object to see if 
    // there's a matching subview, if not, it creates and renders it, otherwise
    // render the existing sub view
    detail: function(id) {
      console.log('detail');
        if (_.isUndefined(app.views.detail[id])) {
          app.views.detail[id] = new Detail({
            el: '#content',
            id: id
          });
        }
        else  {
          app.views.detail[id].render();
        }
    } 
  });

  var Main = Backbone.View.extend({
    initialize: function() {
      // create a collection for the view specifying the URL of the API to use
      // and how to process the returned data
      var Collection = Backbone.Collection.extend({
        url: '/api',
          parse: function(data) {
            return data.collection; 
          }
      });
      this.collection = new Collection();
      // re-rewnder the view whenever we fetch the collection
      this.collection.on('sync', this.render, this);
      this.collection.fetch();
    },

    // first, clear the view's base element, then
    // for each item in the view's collection, render a mustache template, and append it
    // to the view's base element
    render: function() {
      this.$el.html('');
      this.collection.each(function(model) {
        this.$el.append(Mustache.render('<p><a href="#item/{{id}}">{{title}}</a></p>', model.toJSON()));
      }, this);
      return this;
    }
  });

  var Detail = Backbone.View.extend({
    initialize: function(options) {
      // assign a model object to the view
      var Model = Backbone.Model.extend({
        url: '/api/' + options.id
      });
      this.model = new Model();
      // redraw this when the model is refreshed
      this.model.on('sync', this.render, this);
      this.model.fetch();
    },

    render: function() {
      this.$el.html('');
      this.$el.append(Mustache.render('<p>Details about {{title}}</p><p><a href="#">Back</a></p>', this.model.toJSON()));
      return this;
    }
  });

  window.app.router = new Router();
  Backbone.history.start();

})(window); // call this function as soon as it's defined, passing window to it
