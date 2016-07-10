import Ember from 'ember';

export default Ember.Route.extend({
  queryParams: {
    ident: { refreshModel: true },
    title: { refreshModel: true },
    subtitle: { refreshModel: true },
    lcc: { refreshModel: true },
    pages: { refreshModel: true },
    publishDate: { refreshModel: true },
    format: { refreshModel: true },
    createdAt: { refreshModel: true }
  },

  model(params) {
    return this.store.query('edition', params);
  }
});
