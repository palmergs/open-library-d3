import Ember from 'ember';
import d3 from 'd3';

export default Ember.Component.extend({
  data: [
    { label: 'Work', value: 15123122 },
    { label: 'Author', value: 8234232 },
    { label: 'Edition', value: 0 }
  ],

  didInsertElement() {
    this._super(...arguments);

    const width = this.$().width(),
        height = 500,
        radius = Math.min(width, height) / 2;

    const color = d3.scaleOrdinal()
        .range([ '#99afff', '#f27993', '#557755', '#7f3f4d', '#992233', '#112288', '#d8adb6', '#d7d8dd', '#338811' ]);

    const label = d3.scaleOrdinal()
        .range([ '#222222', '#222222', '#ffffff', '#222222', '#222222', '#ffffff', '#222222', '#222222', '#ffffff' ]);

    const arc = d3.arc().
        outerRadius(radius - 10).
        innerRadius(0);

    const pie = d3.pie().
        sort(null).
        value(function(d) { return d.value; });

    const svg = d3.select(this.$().get(0)).
        append('svg').
        attr('width', width).
        attr('height', height).
        append('g').
            attr('transform', 'translate('+ width / 2 +','+ height / 2 +')');

    Ember.$.ajax('/api/v1/charts/metadata/all').done(function(data) {

      console.log("in callback...", data);


      data.forEach(function(d, idx) {
        
        const g = svg.selectAll('.arc').
            data(pie(data)).
            enter().append('g').
                attr('class', 'arc');

        g.append('path').attr('d', arc).style('fill', function(d) { return color(d.data.label); });

        g.append('text').
            attr('transform', function(d) { return "translate("+ arc.centroid(d) +')'; }).
            attr('dy', '.35em').
            attr('text-anchor', 'middle').
            attr('fill', function(d) { return label(d.data.label); }).
            text(function(d) { return d.data.label; });

      });
    });
  }
});
