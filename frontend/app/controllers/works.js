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
    showWork(work) {
      this.transitionToRoute('works.work', work.get('id'));
    }
  }
});
