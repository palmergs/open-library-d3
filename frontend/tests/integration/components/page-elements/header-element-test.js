import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('page-elements/header-element', 'Integration | Component | page elements/header element', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{page-elements/header-element}}`);

  assert.equal(this.$().text().trim().replace(/[\s]+/g, ' '), 'Home Works Authors Editions');
});
