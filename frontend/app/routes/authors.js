import Ember from 'ember';

export default Ember.Route.extend({
  queryParams: {
    ident: { refreshModel: true },
    name:  { refreshModel: true },
    birthDate: { refreshModel: true },
    deathDate: { refreshModel: true },
    createdAt: { refreshModel: true }
  },

  model(params) {
    return this.store.query('author', params);
  }
});
