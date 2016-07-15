import Model from 'ember-data/model';
import attr from 'ember-data/attr';
// import { belongsTo, hasMany } from 'ember-data/relationships';

export default Model.extend({
  ident: attr('string'),
  title: attr('string'),
  subtitle: attr('string'),
  lcc: attr('string'),
  publishDate: attr('number'),
  excerpt: attr('string'),
  description: attr('string'),
  workAuthorsCount: attr('number'),
  createdAt: attr('date')
});
