require 'csv'

class Api::V1::Charts::TokenController < ApplicationController
  include Concerns::PadsTable

  def timeline

    csv = Rails.cache.fetch("token/token-timeline", expires_in: 1.minute) do

      tokens = Array(params[:q])
      header = [ 'Decade', 'Count' ]
      if tokens.empty?
        all = Token.by_type(params[:t]).by_category(params[:c]).select('((year / 10) * 10) as decade, count(*) as count').
            where('year between 1000 and 2016').
            group('decade').
            order('decade asc')
        CSV.generate do |table|
          table << header
          pad_table(table, [ all ])
        end
      else
        (1...tokens.size).each {|n| header << "Count#{ n }" }

        queries = tokens.inject([]) do |token|
          Token.by_type(params[:t]).by_category(params[:c]).select('((year / 10) * 10) as decade, count(*) as count').
              where(token: Token.normalize(token)).
              where('year between 1000 and 2016').
              group('decade').
              order('decade asc')
        end
        CSV.generate do |table|
          table << header
          pad_table(table, queries)
        end
      end
    end
    render text: csv
  end
end
