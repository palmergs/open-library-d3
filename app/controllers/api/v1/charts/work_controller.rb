require 'csv'

class Api::V1::Charts::WorkController < ApplicationController
  include Concerns::PadsTable

  def publish_timeline
    csv = Rails.cache.fetch("work/publish-timeline", expires_in: 1.hour) do
      decades = Work.select('((publish_date / 10) * 10) as publish_decade, count(*) as count').
          where('publish_date between 1000 and 2016').
          group('publish_decade').
          order('publish_decade asc') 
      CSV.generate do |table|
        table << [ 'Decade', 'Count' ]
        pad_table(table, decades, time_method: :publish_decade)
      end
    end
    render text: csv
  end
end

