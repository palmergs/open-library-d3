class WorkSerializer < ActiveModel::Serializer
  attributes :id, :ident, 
      :title, 
      :subtitle, 
      :lcc, 
      :publish_date, 
      :excerpt, 
      :description, 
      :work_authors_count,
      :created_at
end
