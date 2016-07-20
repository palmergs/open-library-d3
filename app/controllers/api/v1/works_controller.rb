class Api::V1::WorksController < ApplicationController
  include Concerns::HasPageNumbers
  include Concerns::HasIndexSort
  def index
   
    query = Work.by_ids(coalesce_ids).
        by_prefix(params[:q]).
        by_year(params[:y])
    @works = query.
        limit(page_size).
        offset(page_number * page_size).
        order(sort_order).
        includes(:authors).
        includes(:editions).
        includes(:subject_tags).
        includes(:external_links)
    render json: @works, meta: {
      pagination: pagination_meta(query)
    }
  end

  def show
    @work = Work.find(params[:id])
    render json: @work
  end
end
