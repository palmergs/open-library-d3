class WorkAuthorSerializer < ActiveModel::Serializer
  attributes :id, :work_id, :author_id, :rel_order
end
