import Ember from 'ember';
import d3 from 'd3';
import HasChartColors from 'frontend/mixins/has-chart-colors';

export default Ember.Component.extend(HasChartColors, {

  classNames: [ 'timeline-chart' ],

  path: null,

  width: null,

  height: 400,

  didInsertElement() {
    this._super(...arguments);

    const margin = { top: 20, right: 90, bottom: 30, left: 40 },
      width = (this.get('width') || this.$().width()) - margin.left - margin.right, // default to element width
      height = (this.get('height') || (width / 4)) - margin.top - margin.bottom; // default to 4:1 ratio height to width

    const colors = this.get('colorRange');
    console.log(colors);
    console.log(colors[0], colors[1]);

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

        chart.selectAll('.b0').
          data(data).
          enter().append('rect').
            attr('class', 'bar').
            attr('class', 'b0').
            attr('fill', colors[0]).
            attr('x', function(d) { return x(+d.Decade); }).
            attr('y', function(d) { return y(+d.Count); }).
            attr('height', function(d) { return height - y(+d.Count); }).
            attr('width', x.bandwidth() / 2);

        chart.selectAll('.b1').
          data(data).
          enter().append('rect').
            attr('class', 'bar').
            attr('class', 'b1').
            attr('fill', colors[1]).
            attr('x', function(d) { return x(+d.Decade) + (x.bandwidth() / 2); }).
            attr('y', function(d) { return y(+d.Count1); }).
            attr('height', function(d) { return height - y(+d.Count1); }).
            attr('width', x.bandwidth() / 2);

      });
    }
  }
});
