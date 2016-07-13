class WorkSerializer < ActiveModel::Serializer
  attributes :id, :ident, 
      :title, 
      :subtitle, 
      :lcc, 
      :publish_date, 
      :excerpt, 
      :description, 
      :created_at,
      :work_authors_count
end
