import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('authors', function() {
    this.route('author', { path: ':id' });
  });
  this.route('works');
  this.route('editions');
  this.route('home');
});

export default Router;
