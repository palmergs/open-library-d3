class Api::V1::AuthorsController < ApplicationController
  def index
    @authors = Author.page(params[:p]).per(params[:cnt] || 20).order(sort_order)
    render json: @authors, meta: {
      pagination: {
        total_pages: @authors.total_pages,
        total_count: @authors.total_count,
        current_page: @authors.current_page
      }
    }
  end

  def show
    @author = Author.find(params[:id])
    render json: @author
  end
end
