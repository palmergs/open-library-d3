import Model from 'ember-data/model';
import attr from 'ember-data/attr';
// import { belongsTo, hasMany } from 'ember-data/relationships';

export default Model.extend({
  linkableId: attr('number'),
  linkableType: attr('string'),
  name: attr('string'),
  value: attr('string'),
  createdAt: attr('date')
});
