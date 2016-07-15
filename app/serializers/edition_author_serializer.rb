class EditionAuthorSerializer < ActiveModel::Serializer
  attributes :id, :edition_id, :author_id, :rel_order
end
