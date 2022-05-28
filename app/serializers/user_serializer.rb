class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :first_name, :last_name, :contact, :role, :email, :created_at, :updated_at, :avatar
  attributes :invitation_status  do |obj|
    obj.invitation_accepted?
  end 
  attributes :initials do |obj|
    obj.first_name[0..0] + obj.last_name[0..0]
  end
end
