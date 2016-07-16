class Api::V1::EditionsController < ApplicationController
  include Concerns::HasPageNumbers
  include Concerns::HasIndexSort
  def index
    @editions = Edition.page(page_number).per(page_size).order(sort_order)
    render json: @editions, meta: {
      pagination: pagination_meta(@editions)
    }
  end

  def show
    @edition = Edition.find(params[:id])
    render json: @edition
  end
end
