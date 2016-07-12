import Ember from 'ember';
import d3 from 'd3';

export default Ember.Component.extend({

  classNames: [ 'timeline-chart' ],

  path: null,

  width: null,

  height: 400,

  colorRange: [ '#99afff', '#f27993', '#557755', '#7f3f4d', '#992233', '#112288', '#d8adb6', '#d7d8dd', '#338811' ],

  didInsertElement() {
    this._super(...arguments);

    const width = this.get('width') || this.$().width(), // default to element width
      height = this.get('height') || (width / 4); // default to 4:1 ratio height to width

    const y = d3.scaleLinear().range([ height, 0 ]);

    const path = this.get('path');
    if(path) {

      const svg = d3.select(this.$().get(0)).
        append('svg').
        attr('width', width).
        attr('height', height);

      Ember.$.ajax(path).done(function(csv) {

        const data = d3.csvParse(csv);
        const max = d3.max(data, function(d) { console.log(d.Count); return +d.Count; });

        y.domain([ 0, max ]);

        const barWidth = width / data.length;

        const bar = svg.selectAll('g').
          data(data).
          enter().append('g').
            attr('transform', function(d, i) { return "translate("+ i * barWidth + ',0)'; });

        bar.append('rect').
          attr('y', function(d) { return y(+d.Count); }).
          attr('height', function(d) { return height - y(+d.Count) + 3; }).
          attr('width', barWidth - 1);

        bar.append('text').
          attr('x', barWidth / 2).
          attr('y', function(d) { return y(+d.Count) + 3; }).
          attr('dy', '.75em').
          text(function(d) { return +d.Count; });
      });
    }
  }
});
