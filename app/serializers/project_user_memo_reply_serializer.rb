class ProjectUserMemoReplySerializer
  include JSONAPI::Serializer
  attributes :id, :content, :created_by, :created_at
end