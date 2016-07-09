class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :ident, 
      :name, 
      :personal_name, 
      :birth_date, 
      :death_date, 
      :death_place, 
      :description, 
      :created_at
end
