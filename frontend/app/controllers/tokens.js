import Ember from 'ember';

export default Ember.Controller.extend({
  queryParams: [ 'q', 'y', 'e', 'c', 't', 'p', 'o', 'd' ],

  q: null,
  y: null,
  e: null,
  c: null,
  t: null,
  p: null,
  o: null,
  d: null,

  path: Ember.computed('pathParams', function() {
    
    const path = `/api/v1/charts/token/timeline?${ this.get('pathParams') }`;
    return path; 
  }),

  pathParams: Ember.computed('fieldNames', 'y', 'e', 'c', 't', function() {
    const arr = this.get('fieldNames');
    const params = [];
    arr.forEach((t) => {
      params.push(`q[]=${ t }`);
    });

    const y = this.get('y');
    if(y) { params.push(`y=${ y }`); }

    const e = this.get('e');
    if(e) { params.push(`e=${ e }`); }

    const c = this.get('c');
    if(c) { params.push(`c=${ c }`); }

    const t = this.get('t');
    if(t) { params.push(`t=${ t }`); }

    return params.join('&');
  }),

  fieldNames: Ember.computed('q', function() {
    const q = this.get('q');
    if(Ember.isEmpty(q)) { 
      return null;
    } else {
      const arr = Array.isArray(q) ? q : q.toString().toLowerCase().split(',');
      return arr;
    }
  }),

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

  // params arrive as strings
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
    resetParam(param) {
      const queryParams = this.get('queryParams');
      if(queryParams.indexOf(param) !== -1) { this.set(param, null); }
    },
    setTokens(str) {
      if(!Ember.isEmpty(str)) {
        const lower = str.toLowerCase();
        let arr = lower.split(',');
        arr = arr.map((s) => { return s.trim(); }); 
        this.set('q', arr.join(','));
      } else {
        this.set('q', null);
      }
    },
    setStartYear(str) {
      const now = new Date().getFullYear();
      const max = this.get('e') ? Math.min(now, parseInt(this.get('e'))) : now;
      this.set('y', this.nullOrIntValue(str, 1, max));
    },
    setEndYear(str) {
      const now = new Date().getFullYear();
      const min = this.get('y') ? Math.max(1, parseInt(this.get('y'))) : 1; 
      this.set('e', this.nullOrIntValue(str, min, now));
    },
    setCategory(str) {
      const cat = this.nullOrIntValue(str, 1, 3);
      this.set('c', cat);
    },
    setType(str) {
      if(Ember.isEmpty(str)) { 
        this.set('t', null);
      } else {
        this.set('t', str);
      }
    },
    setLoading(isLoading) {
      if(isLoading) {
        Ember.$('.token-comparison').addClass('loading');
      } else {
        Ember.$('.token-comparison').removeClass('loading');
      }
    }
  }
});
