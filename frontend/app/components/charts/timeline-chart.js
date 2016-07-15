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

    const margin = { top: 20, right: 90, bottom: 30, left: 40 },
      width = (this.get('width') || this.$().width()) - margin.left - margin.right, // default to element width
      height = (this.get('height') || (width / 4)) - margin.top - margin.bottom; // default to 4:1 ratio height to width

    const x = d3.scaleBand().rangeRound([0, width]);

    const y = d3.scaleLinear().range([ height, 0 ]);

    const path = this.get('path');
    if(path) {

      const chart = d3.select(this.$().get(0)).
        append('svg').
        attr('width', width + margin.left + margin.right).
        attr('height', height + margin.top + margin.bottom).
        append('g').
          attr('transform', 'translate('+ margin.left +','+ margin.top +')');

      

      Ember.$.ajax(path).done(function(csv) {

        const data = d3.csvParse(csv);
        const max = d3.max(data, function(d) { return +d.Count; });

        y.domain([ 0, max ]);
        x.domain(data.map(function(d) { return +d.Decade; }));

        const xAxis = d3.axisBottom().
          scale(x).
          tickValues(x.domain().filter(function(d, i) { return (i % 2) !== 0; }));
        chart.append('g').attr('class', 'x axis').
          attr('transform', 'translate(0,'+ height +')').
          call(xAxis).
          selectAll('text').
            attr('y', 9).
            attr('x', 4).
            attr('dy', '.35em').
            attr('transform', 'rotate(45)').
            style('text-anchor', 'start');

        const yAxis = d3.axisRight().scale(y);
        chart.append('g').attr('class', 'y axis').attr('transform', 'translate('+ width +',0)').call(yAxis);

        chart.selectAll('.bar').
          data(data).
          enter().append('rect').
            attr('class', 'bar').
            attr('x', function(d) { return x(+d.Decade); }).
            attr('y', function(d) { return y(+d.Count); }).
            attr('height', function(d) { return height - y(+d.Count); }).
            attr('width', x.bandwidth());

      });
    }
  }
});
