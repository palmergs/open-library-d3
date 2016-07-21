import Ember from 'ember';
import ParsesParams from 'frontend/mixins/parses-params';

export default Ember.Controller.extend(ParsesParams, {
  queryParams: [ 'q', 'y', 'p', 'o', 'd' ],

  q: null,
  y: null,
  p: null,
  o: null,
  d: null,

  actions: {
    
    selectRow(row) {
      this.transitionToRoute('editions.edition', row.get('id'));
    },

    setYear(str) {
      str = this.strOrInput(str);
      const year = this.nullOrIntValue(str, 1, new Date().getFullYear());
      if(this.get('y') !== year) { this.setProperties({ p: null, q: year }); }
    },

    setSearch(str) {
      str = this.strOrInput(str);
      if(Ember.isEmpty(str)) {
        if(this.get('q')) { this.setProperties({ p: null, q: null }); }
      } else {
        if(this.get('q') !== str) { this.setProperties({ p: null, q: str }); }
      }
    }
  }
});
