class OrganizationSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :phone, :address, :description 
end
