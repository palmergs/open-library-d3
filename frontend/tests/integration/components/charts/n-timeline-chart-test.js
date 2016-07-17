import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('charts/n-timeline-chart.js', 'Integration | Component | charts/n timeline chart.js', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{charts/n-timeline-chart.js}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#charts/n-timeline-chart.js}}
      template block text
    {{/charts/n-timeline-chart.js}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
