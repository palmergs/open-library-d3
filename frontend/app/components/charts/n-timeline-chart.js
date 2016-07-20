import Ember from 'ember';
import d3 from 'd3';
import HasChartColors from 'frontend/mixins/has-chart-colors';

export default Ember.Component.extend(HasChartColors, {

  classNames: [ 'timeline-chart' ],

  path: null,

  params: {},

  width: null,

  height: 400,

  fieldNames: [ 'Count' ],

  dateField: 'Decade',

  didRender() {
    this._super(...arguments);

    const margin = { top: 20, right: 90, bottom: 30, left: 40 },
      width = (this.get('width') || this.$().width()) - margin.left - margin.right,
      height = (this.get('height') || (width / 4)) - margin.top - margin.bottom;

    const colors = this.get('colorRange');

    const x = d3.scaleBand().rangeRound([0, width]);

    const y = d3.scaleLinear().range([ height, 0 ]);

    const path = this.get('path');
    if(path) {

      const fieldNames = this.get('fieldNames');

      const dateField = this.get('dateField');

      // clean out old chart
      this.$('svg').remove();

      const chart = d3.select(this.$().get(0)).
        append('svg').
        attr('width', width + margin.left + margin.right).
        attr('height', height + margin.top + margin.bottom).
        append('g').
          attr('transform', 'translate('+ margin.left +','+ margin.top +')');

      this.sendAction('loading', true);
      Ember.$.ajax(path).done((csv) => {

        this.sendAction('loading', false);

        const data = d3.csvParse(csv);
        const max = d3.max(data, function(d) { 
          let x = 0;
          fieldNames.forEach((field) => { x = Math.max(x, +d[field]); }); // refactor as collect/inject
          return x;
        });

        y.domain([ 0, max ]);
        x.domain(data.map(function(d) { return +d[dateField]; }));

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

        fieldNames.forEach((field, idx) => {
          let key = `b${ idx }`;
          chart.selectAll(`.${ key }`).
            data(data).
            enter().append('rect').
              attr('class', 'bar').
              attr('class', key).
              attr('fill', colors[idx]).
              attr('x', function(d) { return x(+d[dateField]) + (idx * (x.bandwidth() / fieldNames.length)); }).
              attr('y', function(d) { return y(+d[field]); }).
              attr('height', function(d) { return height - y(+d[field]); }).
              attr('width', x.bandwidth() / fieldNames.length);
        });
      });

    }  
  }
});
