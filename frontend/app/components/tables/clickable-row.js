import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'tr',
  classNames: [ 'table-row', 'clickable' ],
  classNameBindings: [ 'isHovering:hover:no-hover' ],
  
  click(evt) {
    evt.preventDefault();
    this.sendAction('action', evt);
    return false;
  },

  mouseEnter() {
    this.set('isHovering', true);
  },

  mouseLeave() {
    this.set('isHovering', false);
  }
});
