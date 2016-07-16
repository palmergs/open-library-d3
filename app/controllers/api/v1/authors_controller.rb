class Api::V1::AuthorsController < ApplicationController
  include Concerns::HasPageNumbers
  include Concerns::HasIndexSort

  def index
    @authors = Author.by_prefix(params[:q]).
        by_year(params[:y]).
        page(page_number).
        per(page_size).
        order(sort_order)
    render json: @authors, meta: { 
      pagination: pagination_meta(@authors)
    }
  end

  def show
    @author = Author.find(params[:id])
    render json: @author
  end
end
