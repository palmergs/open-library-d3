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

  has_many :works
  has_many :subject_tags
  has_many :external_links
end
