import Ember from 'ember';

export default Ember.Route.extend({
  queryParams: {
    q: { refreshModel: true },
    y: { refreshModel: true },
    p: { refreshModel: true },
    o: { refreshModel: true },
    d: { refreshModel: true },
  },

  model(params) {
    return this.store.query('work', params);
  }
});
