import Ember from 'ember';

export default Ember.Controller.extend({
  queryParams: [ 'q', 'y', 'c', 't', 'p', 'o', 'd' ],

  q: null,
  y: null,
  c: null,
  t: null,
  p: null,
  o: null,
  d: null,

  path: Ember.computed('q', function() {
    
    const path = `/api/v1/charts/token/timeline?${ this.get('pathParams') }`;
    return path; 
  }),

  pathParams: Ember.computed('fieldNames', function() {
    const arr = this.get('fieldNames');
    const params = [];
    arr.forEach((t) => {
      params.push(`q[]=${ t }`);
    });
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

  queryString: null,

  stringFromQuery() {
    const q = this.get('q');
    if(Ember.isEmpty(q)) {
      return '';
    } else {
      return Array.isArray(q) ? q.join(',') : q.toString();
    }
  },

  initQueryString: function() {
    const qs = this.stringFromQuery();
    console.log('init', qs);
    this.set('queryString', this.stringFromQuery());
  }.on('init').observes('params'),

  actions: {
    setPage(val) { 
      if(Ember.isEmpty(val) || isNaN(parseInt(val))) { 
        this.set('p', null);
      } else {
        this.set('p', parseInt(val));
      }
    },
    setTokens(str) {
      if(!Ember.isEmpty(str)) {
        const lower = str.toLowerCase();
        let arr = lower.split(',');
console.log(arr);
        arr = arr.map((s) => { return s.trim(); }); 
console.log(arr, arr.join(','));
        this.transitionToRoute('tokens', { queryParams: { q: arr.join(',') } });
      }
    },
    resetTokens() {
      this.set('queryString', this.stringFromQuery());
    },
  }
});
