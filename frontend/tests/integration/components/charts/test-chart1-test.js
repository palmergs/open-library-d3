import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('charts/test-chart1', 'Integration | Component | charts/test chart1', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{charts/test-chart1}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#charts/test-chart1}}
      template block text
    {{/charts/test-chart1}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
