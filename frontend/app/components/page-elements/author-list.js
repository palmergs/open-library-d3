import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  params: null,
  model: null,
  onParamsChanged: function() {
    const params = this.get('params');
    this.get('store').query('author', params).then((results) => {
      this.set('model', results);
    });
  }.observes('params').on('init')
});
