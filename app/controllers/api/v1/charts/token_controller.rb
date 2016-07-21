require 'csv'

class Api::V1::Charts::TokenController < ApplicationController
  include Concerns::PadsTable

  def timeline


    tokens = Array(params[:q])
    now = Date.today.year
    end_year = default_or_int(params[:e], 1, now, now)
    start_year = default_or_int(params[:y], 1, end_year, 1000)
    diff = end_year - start_year
    slice = [[50, diff / 100].min, 1].max

    header = [ 'Decade' ]
    if tokens.empty?
      

      header << 'Count' 
      all = Token.by_type(params[:t]).by_category(params[:c]).select("((year / #{ slice }) * #{ slice }) as decade, count(*) as count").
          where("year between #{ start_year } and #{ end_year }").
          group('decade').
          order('decade asc')
      csv = CSV.generate do |table|
        table << header
        pad_table(table, [ all ], start: start_year, increment: slice, complete: end_year)
      end
      render text: csv
    else

      queries = tokens.each_with_object([]) do |token, array|
        header << token
        array << Token.by_type(params[:t]).by_category(params[:c]).select("((year / #{ slice }) * #{ slice }) as decade, sum(count) as count").
            where(token: Token.normalize(token)).
            where("year between #{ start_year } and #{ end_year }").
            group('decade').
            order('decade asc')
      end
      csv = CSV.generate do |table|
        table << header
        pad_table(table, queries, start: start_year, increment: slice, complete: end_year)
      end
      render text: csv
    end
  end

  private

    def default_or_int val, min, max, default = nil 
      n = Integer(val)
      return min if min && n < min
      return max if max && n > max
      return n
    rescue Exception => e
      default
    end
end
