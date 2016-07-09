class Api::V1::WorksController < ApplicationController
  def index
    @works = Work.page(params[:p]).per(params[:cnt] || 20).order(sort_order)
    render json: @works, meta: {
      pagination: {
        total_pages: @works.total_pages,
        total_count: @works.total_count,
        current_page: @works.current_page
      }
    }
  end

  def show
    @work = Work.find(params[:id])
    render json: @work
  end
end
