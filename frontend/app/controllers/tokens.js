import Ember from 'ember';
import ParsesParams from 'frontend/mixins/parses-params';

export default Ember.Controller.extend(ParsesParams, {
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
      str = this.strOrInput(str);
      const q = this.get('q');
      if(!Ember.isEmpty(str)) {
        let arr = str.toLowerCase().split(',');
        arr = arr.map((s) => { return s.trim(); }); 
        const val = arr.join(',');
        if(val !== q) { this.set('q', val); }
      } else {
        if(q) { this.set('q', null); }
      }
    },
    
    setStartYear(str) {
      str = this.strOrInput(str);
      const now = new Date().getFullYear();
      const max = this.get('e') ? Math.min(now, parseInt(this.get('e'))) : now;
      const n = this.nullOrIntValue(str, 1, max);
      if(this.get('y') !== n) { this.set('y', n); }
    },

    setEndYear(str) {
      str = this.strOrInput(str);
      const now = new Date().getFullYear();
      const min = this.get('y') ? Math.max(1, parseInt(this.get('y'))) : 1; 
      const n = this.nullOrIntValue(str, min, now);
      if(this.get('e') !== n) { this.set('e', n); }
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
