class Api::V1::ExternalLinksController < ApplicationController
  include Concerns::HasPageNumbers
  include Concerns::HasIndexSort
  def index
    query = ExternalLink.by_ids(coalesce_ids)
    @external_links = query.
        limit(page_size).
        offset(page_number * page_size).
        order(sort_order)
    render json: @external_links, meta: {
      pagination: pagination_meta(query)
    }
  end

  def show
    @external_link = ExternalLink.find(params[:id])
    render json: @external_link
  end
end

