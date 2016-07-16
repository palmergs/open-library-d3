import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    return { year: params.year, n: 10 };
  }
});
