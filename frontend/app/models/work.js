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

  authors: hasMany('author', { async: true }),
  editions: hasMany('edition', { async: true }),

  subjectTags: hasMany('subject-tag', { async: true }),
  externalLink: hasMany('external-link', { async: true }),

});
