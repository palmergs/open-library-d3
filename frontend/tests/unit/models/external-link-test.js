import { moduleForModel, test } from 'ember-qunit';

moduleForModel('external-link', 'Unit | Model | external link', {
  // Specify the other units that are required for this test.
  needs: []
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});
