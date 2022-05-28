class StorageDatumSerializer
  include JSONAPI::Serializer
  # attributes :items do |obj|
  #   result = {}
  #   result[:id] = obj.id
  #   result[:user_storage_id] = obj.user_storage_id
  #   result[:project_id] = obj.project_id
  #   result[:name] = obj.name
  #   result[:isDirectory] = obj.isDirectory
  #   result[:size] = obj.size
  #   result[:parent_id] = obj.parent_id
  #   result[:__KEY__] = obj.__KEY__
  #   result
  # end
  attributes :id, :user_storage_id, :project_id, :name, :isDirectory, :size, :parent_id, :__KEY__
end

