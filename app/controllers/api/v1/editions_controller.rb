class Api::V1::EditionsController < ApplicationController
  include Concerns::HasPageNumbers
  include Concerns::HasIndexSort
  
  def index
    query = Edition.by_ids(coalesce_ids).
        by_prefix(params[:q]).
        by_year(params[:y])
    @editions = query.
        limit(page_size).
        offset(page_number * page_size).
        order(sort_order).
        includes(:works).
        includes(:external_links).
        includes(:subject_tags)
    render json: @editions, meta: {
      pagination: pagination_meta(query)
    }
  end

  def show
    @edition = Edition.find(params[:id])
    render json: @edition
  end
end
