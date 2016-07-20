class Api::V1::AuthorsController < ApplicationController
  include Concerns::HasPageNumbers
  include Concerns::HasIndexSort

  def index
    query =  Author.by_ids(coalesce_ids).
        by_prefix(params[:q]).
        by_year(params[:y])
    @authors = query.
        limit(page_size).
        offset(page_number * page_size).
        order(sort_order).
        includes(:works).
        includes(:subject_tags).
        includes(:external_links)
    render json: @authors, meta: { 
      pagination: pagination_meta(query)
    }
  end

  def show
    @author = Author.find(params[:id])
    render json: @author
  end
end
