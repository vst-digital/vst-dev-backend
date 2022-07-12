class CalanderSerializer
  include JSONAPI::Serializer

  attributes :id, :location, :user, :project
  
  attributes :title do |obj|
    obj.subject
  end
  attributes :start do |obj|
    obj.start_date
  end
  attributes :end do |obj|
    obj.end_date
  end

end
