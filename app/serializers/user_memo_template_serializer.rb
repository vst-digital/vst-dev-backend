class UserMemoTemplateSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :number, :user_id, :project_id, :template, :created_at, :updated_at
end