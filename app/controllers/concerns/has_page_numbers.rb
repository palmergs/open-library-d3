module Concerns
  module HasPageNumbers
    extend ActiveSupport::Concern

    def page_number
      params.fetch(:p, 0)
    end

    def page_size
      params.fetch(:n, coalesce_ids ? coalesce_ids.size : 20)
    end

    def pagination_meta query
      if query.respond_to?(:total_pages)
        {
          total_pages: query.total_pages,
          total_count: query.total_count,
          current_page: query.current_page
        }
      end
    end

    def filter_params
      filters = params.fetch(:filter, {})
      filters[:ids] = filters[:id].to_s.split(',').map(&:to_i) if filters[:id].present?
      filters
    end

    def coalesce_ids
      filter_params[:ids]
    end
  end
end
