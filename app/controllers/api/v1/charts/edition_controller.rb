require 'csv'

class Api::V1::Charts::EditionController < ApplicationController

  def publish_timeline
    csv = Rails.cache.fetch("edition/publish-timeline", expires_in: 1.hour) do
      decades = Edition.select('((publish_date / 10) * 10) as publish_decade, count(*) as count').
          where('publish_date between 1000 and 2016').
          group('publish_decade').
          order('publish_decade asc')
      CSV.generate do |table|
        table << [ 'Decade', 'Count' ]
        decades.each do |decade|
          table << [ decade.publish_decade, decade.count ]
        end
      end
    end
    render text: csv
  end
end
