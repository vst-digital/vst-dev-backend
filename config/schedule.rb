every :day, at: '12:20am', roles: [:app] do
  rake "dbdump:dump" 
end