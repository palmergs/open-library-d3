import Ember from 'ember';
import d3 from 'd3';

export default Ember.Component.extend({

  path: null,

  width: null,

  height: 200,

  colorRange: [ '#99afff', '#f27993', '#557755', '#7f3f4d', '#992233', '#112288', '#d8adb6', '#d7d8dd', '#338811' ],

  labelColorRange: [ '#222222', '#222222', '#ffffff', '#ffffff', '#ffffff', '#ffffff', '#222222', '#222222', '#ffffff' ],

  didInsertElement() {
    this._super(...arguments);

    const width = this.get('width') || this.$().width(), // default to element width
        height = this.get('height') || width, // default to width of chart 
        radius = Math.min(width, height) / 2;

    const color = d3.scaleOrdinal().range(this.get('colorRange'));

    const label = d3.scaleOrdinal().range(this.get('labelColorRange'));

    const arc = d3.arc().outerRadius(radius - 10).innerRadius(0);

    const pie = d3.pie().sort(null).value(function(d) { return d.value; });

    const path = this.get('path');

    const labelInSegment = function(d) { return d.endAngle - d.startAngle > 0.8; };

    if(path) {
      const svg = d3.select(this.$().get(0)).
        append('svg').
        attr('width', width).
        attr('height', height).
        append('g').
          attr('transform', 'translate('+ width / 2 +','+ height / 2 +')');

      Ember.$.ajax(path).done(function(data) {
        
        const g = svg.selectAll('.arc').
          data(pie(data)).
          enter().append('g').
            attr('class', 'arc');

        g.append('path').attr('d', arc).style('fill', function(d) { return color(d.data.label); });

        g.append('text').
          attr('transform', function(d) {
            const center = arc.centroid(d);
            if(labelInSegment(d)) {
              return "translate("+ center +")";
            } else {
              return "translate("+ (center[0] * 2.1) +','+ (center[1] * 2.1) + ')';
            }
          }).
          attr('dy', '.35em').
          attr('text-anchor', function(d) {
            if(labelInSegment(d)) {
              return 'middle';
            } else {
              if(d.startAngle < 3.0) {
                return 'start';
              } else if(d.startAngle > 3.3) {
                return 'end';
              } else {
                return 'middle';
              }
            }
          }).
          attr('fill', function(d) {
            if(labelInSegment(d)) {
              return label(d.data.label);
            } else {
              label(d.data.label); // don't use color, but register it so that index remains aligned
              return '#222222';
            }
          }).
          text(function(d) { return d.data.label; });

      });
    }
  }
});
