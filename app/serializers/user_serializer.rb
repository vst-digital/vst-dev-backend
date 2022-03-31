class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :first_name, :last_name, :contact, :role, :email, :created_at, :updated_at
  attributes :invitation_status  do |obj|
    obj.invitation_accepted?
  end 
end
