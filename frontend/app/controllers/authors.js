import Ember from 'ember';

export default Ember.Controller.extend({
  queryParams: [ 'ident', 'name', 'createdAt', 'birthDate', 'deathDate' ]
});
