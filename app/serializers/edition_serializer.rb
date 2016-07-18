class EditionSerializer < ActiveModel::Serializer
  attributes :id, :ident,
      :title,
      :subtitle,
      :statement,
      :lcc,
      :pages,
      :publish_date,
      :format,
      :series,
      :excerpt,
      :description,
      :edition_authors_count,
      :work_editions_count,
      :created_at

  has_many :works, include: true
  has_many :subject_tags, include: true
  has_many :external_links, include: true
end
