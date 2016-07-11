require 'csv'

class Api::V1::Charts::AuthorController < ApplicationController

  def birth_timeline
    @decades = Author.select('((birth_date / 10) * 10) as birth_decade, count(*) as count').
        where('birth_date between 32 and 2016').
        group('birth_decade').
        order('birth_decade asc') 
    csv = CSV.generate do |table|
      table << [ 'Decade', 'Count' ]
      @decades.each do |decade|

        table << [ decade.birth_decade, decade.count ]
      end
    end

    render text: csv
  end
end
