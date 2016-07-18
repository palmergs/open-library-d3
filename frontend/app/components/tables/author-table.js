import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'table',
  classNames: [ 'table' ],

  actions: {
    setPage(pg) {
      this.sendAction('setPage', pg);
    },
    selectRow(row) {
      this.sendAction('selectRow', row);
    },
    sortColumn(col, dir) {
      this.sendAction('sortColumn', col, dir);
    }
  }
});
