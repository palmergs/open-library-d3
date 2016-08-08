module Concerns
  module HasPageNumbers
    extend ActiveSupport::Concern

    def page_number
      [ params.fetch(:p, 1).to_i - 1, 0 ].max
    end

    def page_size
      [ params.fetch(:n, coalesce_ids ? coalesce_ids.size : 20).to_i, 1 ].max
    end

    def pagination_meta query
      if coalesce_ids
        { total_pages: 1, total_count: coalesce_ids.size, current_page: 1 }
      else
        # count = query.count(:id)
        count = estimate_count # estimate for large tables
        pages = count / page_size
        pages += 1 unless count % page_size == 0
        {
          total_pages: pages,
          total_count: count,
          current_page: page_number + 1
        }
      end
    end

    def estimate_count
      # HACK: for the time being limit count to 1M until Postgres count(*) 
      # performance can be resolved
      coalesce_ids ? coalesce_ids.size : 1_000_000
    end

    def filter_params
      filters = params.fetch(:filter, {})
      filters[:ids] = filters[:id].to_s.split(',').map(&:to_i) if filters[:id].present?
      filters
    end

    def coalesce_ids
      @_coalesce_ids ||= filter_params[:ids]
    end
  end
end
