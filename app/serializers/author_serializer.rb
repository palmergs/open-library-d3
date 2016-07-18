class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :ident, 
      :name, 
      :birth_date, 
      :death_date, 
      :description, 
      :created_at

  has_many :works, include: true
  has_many :subject_tags, include: true
  has_many :external_links, include: true
end
