class TokenSerializer < ActiveModel::Serializer
  attributes :id, :token_type, :category, :year, :token, :count
end
