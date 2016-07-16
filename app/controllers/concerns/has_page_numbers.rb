module Concerns
  module HasPageNumbers
    extend ActiveSupport::Concern

    def page_number
      params.fetch(:page, {}).fetch(:number, 0)
    end

    def page_size
      params.fetch(:page, {}).fetch(:size, 25)
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
