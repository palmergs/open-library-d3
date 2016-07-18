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

  has_many :authors
  has_many :editions
  has_many :subject_tags
  has_many :external_links
end
