require 'csv'

class Api::V1::Charts::AuthorController < ApplicationController

  def birth_timeline
    csv = Rails.cache.fetch("author/birth-timeline", expires_in: 1.minute) do
      decades = Author.select('((birth_date / 10) * 10) as birth_decade, count(*) as count').
          where('birth_date between 1000 and 2016').
          group('birth_decade').
          order('birth_decade asc') 
      CSV.generate do |table|
        table << [ 'Decade', 'Count' ]
        append_with_empty(table, decades, :birth_decade, :count, 1000, 10, 2020)
      end
    end
    render text: csv
  end

  # TODO: make this a concern
  def append_with_empty table, query, time_method, count_method, start = 1000, increment = 10, complete = 2020
    last = start
    query.each do |entry|
      time = entry.public_send(time_method.to_sym)
      while last.nil? || last < time
        table << [ last, 0 ]
        last = last + increment
      end
      table << [ time, entry.public_send(count_method.to_sym) ]
      last = time + increment
    end
    while last.nil? || last < complete
      table << [ last, 0 ]
      last = last + increment
    end
  end
end
