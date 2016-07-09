class EditionSerializer < ActiveModel::Serializer
  attributes :id, :ident,
      :title,
      :subtitle,
      :lcc,
      :pages,
      :copyright_date,
      :publish_date,
      :publish_country,
      :format,
      :series,
      :first_sentence,
      :description,
      :created_at
end
