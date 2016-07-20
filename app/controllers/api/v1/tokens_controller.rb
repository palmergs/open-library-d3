class Api::V1::TokensController < ApplicationController
  include Concerns::HasPageNumbers
  include Concerns::HasIndexSort

  def index
    query = Token.by_token(params[:q]).
        by_type(params[:t]).
        by_year(params[:y])

    @tokens = query.limit(page_size).offset(page_number * page_size).order(sort_order)
    render json: @tokens, meta: {
      pagination: pagination_meta(query)
    }
  end

  def show
    @token = Token.find(params[:id])
    render json: @token
  end
end

