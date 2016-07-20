class Api::V1::SubjectTagsController < ApplicationController
  include Concerns::HasPageNumbers
  include Concerns::HasIndexSort
  def index
    query = SubjectTag.by_ids(coalesce_ids).
    @subject_tags = query.
        limit(page_size).
        offset(page_number * page_size).
        order(sort_order)
    render json: @subject_tags, meta: {
      pagination: pagination_meta(@subject_tags)
    }
  end

  def show
    @subject_tag = SubjectTag.find(params[:id])
    render json: @subject_tag
  end
end

