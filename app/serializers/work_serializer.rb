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

  has_many :authors, embed: :ids, include: true
  has_many :editions, embed: :ids, include: true
  has_many :subject_tags, embed: :ids, include: true
  has_many :external_links, embed: :ids, include: true
end
