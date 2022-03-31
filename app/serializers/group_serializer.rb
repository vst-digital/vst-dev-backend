class GroupSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description, :users
end
