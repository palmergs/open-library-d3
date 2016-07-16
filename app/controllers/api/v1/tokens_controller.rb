class Api::V1::TokensController < ApplicationController
  include Concerns::HasPageNumbers
  include Concerns::HasIndexSort
  def index
    @tokens = Token.by_token(params[:q]).
        by_parent(params[:t]).
        by_year(params[:y]).
        page(page_number).per(page_size).order(sort_order)
    render json: @tokens, meta: {
      pagination: pagination_meta(@tokens)
    }
  end

  def show
    @token = Token.find(params[:id])
    render json: @token
  end
end

