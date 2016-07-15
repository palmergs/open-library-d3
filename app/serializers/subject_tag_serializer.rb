class SubjectTagSerializer < ActiveModel::Serializer
  attributes :id, :taggable_id, :taggable_type, :name, :value, :created_at
end
