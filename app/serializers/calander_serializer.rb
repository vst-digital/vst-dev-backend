class CalanderSerializer
  include JSONAPI::Serializer
  attributes :id, :subject ,:start_date, :end_date, :location, :user, :project
end
