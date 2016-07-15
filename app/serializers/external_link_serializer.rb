class ExternalLinkSerializer < ActiveModel::Serializer
  attributes :id, :linkable_id, :linkable_type, :name, :value, :created_at
end
