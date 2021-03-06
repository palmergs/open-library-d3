module Concerns
  module HasIndexSort
    extend ActiveSupport::Concern

    def sort_order
      col, dir = sort_params
      if sort_columns.include?(col)
        { col => dir }
      else
        default_sort
      end
    end

    def default_sort
      nil
    end

    def sort_columns
      [ 'id' ]
    end

    def sort_params
      [ params[:o], sort_direction ]
    end

    def sort_direction
      params[:d].to_s == 'desc' ? 'desc' : 'asc'
    end

    def params_key
      keys = params.keys
      arr = keys.sort.each_with_object([]) do |k, arr|
        v = params[k]
        if v.present?
          arr << "#{ k }=#{ v.is_a?(Enumerable) ? v.map(&:to_s).join(',') : v.to_s }"
        end
      end
      arr.join('|')
    end
  end
end
