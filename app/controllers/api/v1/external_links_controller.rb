class Api::V1::ExternalLinksController < ApplicationController
  include Concerns::HasPageNumbers
  include Concerns::HasIndexSort
  def index
    @external_links = ExternalLink.byt_ids(params[:ids]).
        page(page_number).
        per(page_size).
        order(sort_order)
    render json: @external_links, meta: {
      pagination: pagination_meta(@external_links)
    }
  end

  def show
    @external_link = ExternalLink.find(params[:id])
    render json: @external_link
  end
end

