class StorageDatumSerializer
  include JSONAPI::Serializer

  attributes :id, :project_id, :name, :isDirectory, :size, :parent_id, :__KEY__
  attributes :items do |obj|
    result = []
    hash = {} 
    obj.uploads_blobs.each do |blobs|
      hash["id"] = blobs.id
      hash["filename"] = blobs.filename
      hash["created_at"] = blobs.created_at
      hash["url"] = blobs.url
      hash["isDirectory"] = false
      hash["size"] = blobs.byte_size
      result.append(hash)
    end 
    result
  end
end

