import Ember from 'ember';

export default Ember.Controller.extend({
  queryParams: [ 'q', 'y', 'p', 'o', 'd' ],

  q: null,
  y: null,
  p: null,
  o: null,
  d: null,

  actions: {
    setPage(val) { 
      if(Ember.isEmpty(val) || isNaN(parseInt(val))) { 
        this.set('p', null);
      } else {
        this.set('p', parseInt(val));
      }
    },
    showEdition(edition) {
      this.transitionToRoute('editions.edition', edition.get('id'));
    }
  }
});
