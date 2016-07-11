require 'csv'

class Api::V1::Charts::WorkController < ApplicationController

  def publish_timeline
    @decades = Work.select('((publish_date / 10) * 10) as publish_decade, count(*) as count').
        where('publish_date between 32 and 2016').
        group('publish_decade').
        order('publish_decade asc') 
    csv = CSV.generate do |table|
      table << [ 'Decade', 'Count' ]
      @decades.each do |decade|

        table << [ decade.publish_decade, decade.count ]
      end
    end

    render text: csv
  end
end

