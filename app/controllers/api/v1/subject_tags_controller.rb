class Api::V1::SubjectTagsController < ApplicationController
  include Concerns::HasPageNumbers
  include Concerns::HasIndexSort
  def index
    @subject_tags = SubjectTag.by_ids(params[:ids]).
        page(page_number).
        per(page_size).
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

