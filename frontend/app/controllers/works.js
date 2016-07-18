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
    selectRow(row) {
      this.transitionToRoute('works.work', row.get('id'));
    },
    sortColumn(col, dir) {
      if(Ember.isEmpty(col)) {
        this.set('o', null);
        this.set('d', null);
      } else {
        this.set('o', col);
        this.set('d', Ember.isEmpty(dir) ? 'asc' : dir);
      }
    }
  }
});
