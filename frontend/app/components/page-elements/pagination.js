import Ember from 'ember';

export default Ember.Component.extend({
  currentPage: Ember.computed('model.meta', function() {
    const pg = this.get('model.meta').pagination['current-page'];
    return pg;
  }),
  lastPage: Ember.computed('model', function() {
    const pg = this.get('model.meta').pagination['total-pages'];
    return pg;
  }),
  isFirst: Ember.computed('currentPage', function() {
    const pg = this.get('currentPage');
    return pg === 1;
  }),
  isLast: Ember.computed('currentPage', 'lastPage', function() {
    const pg = this.get('currentPage');
    return pg === this.get('lastPage');
  }),
  pages: Ember.computed('currentPage', 'lastPage', function() {
    const pg = this.get('currentPage');
    const min = Math.max(pg - 4, 1);
    const max = Math.min(pg + 4, this.get('lastPage'));
    const arr = [];
    for(let i = min; i < pg; ++i) { arr.push({ page: i, current: false}); }
    arr.push({ page: pg, current: true });
    for(let i = pg + 1; i <= max; ++i) { arr.push({ page: i, current: false }); }
    return arr;
  }),
  actions: {
    pageSelected(val) {
      this.sendAction('action', +val);
    }
  }
});
