class UserShowSerializer < ActiveModel::Serializer
  attributes :id, :email
  has_many :posts, serializer: PostIndexSerializer
end
