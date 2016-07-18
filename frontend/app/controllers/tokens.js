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
      if(Ember.isEmpty(str)) {
        this.set('q', null);
        this.set('p', null);
      } else {
        const tokens = str.split(',');
        console.log(str, tokens);
        this.set('q', tokens);
        this.set('p', null);
      }
    },
    resetTokens() {
      this.set('queryString', this.stringFromQuery());
    },
  }
});
