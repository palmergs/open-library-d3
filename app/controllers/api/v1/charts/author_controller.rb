require 'csv'

class Api::V1::Charts::AuthorController < ApplicationController
  include Concerns::PadsTable

  def birth_timeline
    csv = Rails.cache.fetch("author/birth-timeline", expires_in: 1.minute) do
      decades1 = Author.select('((birth_date / 10) * 10) as decade, count(*) as count').
          where('birth_date between 1000 and 2016').
          group('decade').
          order('decade asc') 
      decades2 = Author.select('((death_date / 10) * 10) as decade, count(*) as count').
          where('death_date between 1000 and 2016').
          group('decade').
          order('decade asc')
      CSV.generate do |table|
        table << [ 'Decade', 'Count', 'Count1' ]
        pad_table(table, [ decades1, decades2 ])
      end
    end
    render text: csv
  end
end
