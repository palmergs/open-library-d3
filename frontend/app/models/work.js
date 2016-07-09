import Model from 'ember-data/model';
import attr from 'ember-data/attr';
// import { belongsTo, hasMany } from 'ember-data/relationships';

export default Model.extend({
  ident: attr('string'),
  title: attr('string'),
  subtitle: attr('string'),
  lcc: attr('string'),
  editionsCount: attr('number'),
  publishDate: attr('number'),
  sentence: attr('string'),
  description: attr('string'),
  createdAt: attr('date')
});
