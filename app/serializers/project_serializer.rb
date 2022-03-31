class ProjectSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :status, :project_description, :created_at, :updated_at, :groups
end
