import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import { hasMany } from 'ember-data/relationships';

export default Model.extend({
  ident: attr('string'),
  title: attr('string'),
  subtitle: attr('string'),
  statment: attr('string'),
  lcc: attr('string'),
  pages: attr('number'),
  publishDate: attr('number'),
  format: attr('string'),
  series: attr('string'),
  excerpt: attr('string'),
  description: attr('string'),
  editionAuthorsCount: attr('number'),
  workEditionsCount: attr('number'),
  createdAt: attr('date'),

  works: hasMany('work'),

  subjectTags: hasMany('subject-tag'),
  externalLinks: hasMany('external-link')
});
