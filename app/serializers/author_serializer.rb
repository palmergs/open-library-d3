class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :ident, 
      :name, 
      :birth_date, 
      :death_date, 
      :description, 
      :created_at
end
