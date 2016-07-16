import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('authors', function() {
    this.route('author', { path: ':id' });
    this.route('year', { path: 'year/:year' });
  });
  this.route('works', function() {
    this.route('work', { path: ':id' });
  });
  this.route('editions', function() {
    this.route('edition', { path: ':id' });
  });
  this.route('home');
});

export default Router;
