class Api::V1::TokensController < ApplicationController
  include Concerns::HasPageNumbers
  include Concerns::HasIndexSort
  def index
    @tokens = Token.page(page_number).per(page_size).order(sort_order)
    render json: @tokens, meta: {
      pagination: pagination_meta(@tokens)
    }
  end

  def show
    @token = Token.find(params[:id])
    render json: @token
  end
end

