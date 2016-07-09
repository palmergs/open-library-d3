class WorkSerializer < ActiveModel::Serializer
  attributes :id, :ident, 
      :title, 
      :subtitle, 
      :lcc, 
      :editions_count, 
      :publish_date, 
      :sentence, 
      :description, 
      :created_at
end
