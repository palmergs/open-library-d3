import Ember from 'ember';
import HasChartColorsMixin from 'frontend/mixins/has-chart-colors';
import { module, test } from 'qunit';

module('Unit | Mixin | has chart colors');

// Replace this with your real tests.
test('it works', function(assert) {
  let HasChartColorsObject = Ember.Object.extend(HasChartColorsMixin);
  let subject = HasChartColorsObject.create();
  assert.ok(subject);
});
