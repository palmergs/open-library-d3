import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('charts/timeline-chart', 'Integration | Component | charts/timeline chart', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{charts/timeline-chart}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#charts/timeline-chart}}
      template block text
    {{/charts/timeline-chart}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
