import Ember from 'ember';

export default Ember.Route.extend({
  queryParams: {
    q: { refreshModel: true },
    y: { refreshModel: true },
    e: { refreshModel: true },
    c: { refreshModel: true },
    t: { refreshModel: true },
    p: { refreshModel: true },
    o: { refreshModel: true },
    d: { refreshModel: true },
  },

  model(params) {
    return params;
  }
});
