import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('authors');
  this.route('works');
  this.route('editions');
  this.route('home');
});

export default Router;
