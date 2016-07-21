import Ember from 'ember';

export default Ember.Mixin.create({
  nullOrIntValue(str, min, max) {
    if(Ember.isEmpty(str)) {
      return null;
    } else {
      const n = parseInt(str);
      if(isNaN(n)) { return null; }
      if(min && n < min) { return min; }
      if(max && n > max) { return max; }
      return n;
    }
  },

  // blur returns the input but keyEvents returns the value
  strOrInput(thing) {
    if(thing) {
      if(thing.substring) { return thing; }
      return thing.target.value;
    } else {
      return null;
    }
  },

  // params arrive as strings but are integers internally; use string for form comparison
  catStr: Ember.computed('c', function() { 
    const c = this.get('c');
    if(c) { return c.toString(); }
    else { return null; }
  }),

  actions: {
    setPage(val) { 
      if(Ember.isEmpty(val) || isNaN(parseInt(val))) { 
        this.set('p', null);
      } else {
        this.set('p', parseInt(val));
      }
    },

    sortColumn(col, dir) {
      if(Ember.isEmpty(col)) {
        this.set('o', null);
        this.set('d', null);
      } else {
        this.set('o', col);
        this.set('d', Ember.isEmpty(dir) ? 'asc' : dir);
      }
    },

    resetParam(param) {
      const queryParams = this.get('queryParams');
      if(queryParams.indexOf(param) !== -1) { this.set(param, null); }
    }
  }
});
