require 'csv'

class Api::V1::Charts::AuthorController < ApplicationController
  include Concerns::PadsTable

  def birth_timeline
    csv = Rails.cache.fetch("author/birth-timeline", expires_in: 1.minute) do
      decades = Author.select('((birth_date / 10) * 10) as birth_decade, count(*) as count').
          where('birth_date between 1000 and 2016').
          group('birth_decade').
          order('birth_decade asc') 
      CSV.generate do |table|
        table << [ 'Decade', 'Count' ]
        pad_table(table, decades, time_method: :birth_decade)
      end
    end
    render text: csv
  end
end
