class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def sort_order
    col, dir = sort_params
    if sort_columns.include?(col)
      { col => dir }
    else
      default_sort
    end
  end

  def default_sort
    { id: :desc }
  end

  def sort_columns
    [ 'id' ]
  end

  def sort_params
    [ params[:o], sort_direction ]
  end

  def sort_direction
    params[:d].to_s == 'desc' ? 'desc' : 'asc'
  end

end
