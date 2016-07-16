class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :ident, 
      :name, 
      :birth_date, 
      :death_date, 
      :description, 
      :created_at

  has_many :subject_tags
  has_many :external_links
end
