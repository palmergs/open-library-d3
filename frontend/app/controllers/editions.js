import Ember from 'ember';

export default Ember.Controller.extend({
  queryParams: [ 'ident', 'title', 'subtitle', 'lcc', 'pages', 'publishDate', 'format', 'createdAt' ]
});
