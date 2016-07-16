import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import { hasMany } from 'ember-data/relationships';

export default Model.extend({
  ident: attr('string'),
  name: attr('string'),
  birthDate: attr('number'),
  deathDate: attr('number'),
  description: attr('string'),
  createdAt: attr('date'),

  subjectTags: hasMany('subject-tag')
});
