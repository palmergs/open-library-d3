import Ember from 'ember';

export default Ember.Controller.extend({
  queryParams: [ 'ident', 'title', 'subtitle', 'publishDate', 'editionsCount', 'createdAt', 'lcc' ]
});
