import Ember from 'ember';

export default Ember.Route.extend({
  queryParams: {
    ident: { refreshModel: true },
    title: { refreshModel: true },
    subtitle: { refreshModel: true },
    publishDate: { refreshModel: true },
    editionsCount: { refreshModel: true },
    lcc: { refreshModel: true },
    createdAt: { refreshModel: true }
  },

  model(params) {
    return this.store.query('work', params);
  }
});
