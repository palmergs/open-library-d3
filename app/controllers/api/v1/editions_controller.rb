class Api::V1::EditionsController < ApplicationController
  def index
    @editions = Edition.page(params[:p]).per(params[:cnt] || 20).order(sort_order)
    render json: @editions, meta: {
      pagination: {
        total_pages: @editions.total_pages,
        total_count: @editions.total_count,
        current_page: @editions.current_page
      }
    }
  end

  def show
    @edition = Edition.find(params[:id])
    render json: @edition
  end
end
