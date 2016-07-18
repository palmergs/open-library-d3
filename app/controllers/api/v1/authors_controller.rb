class Api::V1::AuthorsController < ApplicationController
  include Concerns::HasPageNumbers
  include Concerns::HasIndexSort

  def index
    @authors = Author.by_ids(coalesce_ids).
        by_prefix(params[:q]).
        by_year(params[:y]).
        page(page_number).
        per(page_size).
        order(sort_order).
        includes(:works).
        includes(:subject_tags).
        includes(:external_links)
    render json: @authors, meta: { 
      pagination: pagination_meta(@authors)
    }
  end

  def show
    @author = Author.find(params[:id])
    render json: @author
  end
end
