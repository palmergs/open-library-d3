import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  params: null,
  model: null,
  onParamsChanged: function() {
    this.get('store').query('work', this.get('params')).then((results) => {
      this.set('model', results);
    });
  }.observes('params').on('init')
});
