require 'csv'

class Api::V1::Charts::TokenController < ApplicationController
  include Concerns::PadsTable

  def timeline


    tokens = Array(params[:q])
    header = [ 'Decade' ]
    if tokens.empty?

      header << 'Count' 
      all = Token.by_type(params[:t]).by_category(params[:c]).select('((year / 10) * 10) as decade, count(*) as count').
          where('year between 1000 and 2016').
          group('decade').
          order('decade asc')
      csv = CSV.generate do |table|
        table << header
        pad_table(table, [ all ])
      end
      render text: csv
    else

      queries = tokens.each_with_object([]) do |token, array|
        header << token
        array << Token.by_type(params[:t]).by_category(params[:c]).select('((year / 10) * 10) as decade, sum(count) as count').
            where(token: Token.normalize(token)).
            where('year between 1000 and 2016').
            group('decade').
            order('decade asc')
      end
      csv = CSV.generate do |table|
        table << header
        pad_table(table, queries)
      end
      render text: csv
    end
  end
end
