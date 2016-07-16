module Concerns
  module HasPageNumbers
    extend ActiveSupport::Concern

    def page_number
      params.fetch(:p, 0)
    end

    def page_size
      params.fetch(:n, 20)
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
  end
end
