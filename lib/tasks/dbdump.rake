namespace :dbdump do
  desc "dbdump"
  task :dump => :environment do
    cmd = nil
    cmd = "pg_dump --dbname=postgresql://#{Rails.application.credentials.db_username}:#{Rails.application.credentials.db_password}@127.0.0.1:5432/#{Rails.application.credentials.db_development} --verbose > #{Rails.root}/db/#{Time.now.to_date.to_s}.dump"
    exec cmd
  end
end
