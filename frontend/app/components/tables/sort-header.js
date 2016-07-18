import Ember from 'ember';

export default Ember.Component.extend({
  column: null,
  direction: 'asc',
  click(evt) {
    this.sendAction('action', this.get('column'), this.get('direction'));
  }
});
