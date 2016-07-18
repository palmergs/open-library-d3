import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import { hasMany } from 'ember-data/relationships';

export default Model.extend({
  ident: attr('string'),
  title: attr('string'),
  subtitle: attr('string'),
  lcc: attr('string'),
  publishDate: attr('number'),
  excerpt: attr('string'),
  description: attr('string'),
  workAuthorsCount: attr('number'),
  createdAt: attr('date'),

  authors: hasMany('author'),
  editions: hasMany('edition'),

  subjectTags: hasMany('subject-tag'),
  externalLink: hasMany('external0link'),

});
