require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false
  config.active_storage.variant_processor = :mini_magic
  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true
  # config.force_ssl = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :amazon
  
  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log
  

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true
  # Rails.application.config.action_cable.allowed_request_origins = ['http://localhost:3001', 'http://54.253.73.42:8080', 'http://www.vstapp.co.za/', 'http://vstapp.co.za/', 'https://www.vstapp.co.za/', 'http://www.vstapp.co.za/']
  # ActionCable.server.config.allowed_request_origins = %w( wss://www.vstapp.co.za/  )
  config.action_cable.url = [/ws:\/\/*/, /wss:\/\/*/]
  config.action_cable.allowed_request_origins = [/http:\/\/*/, /https:\/\/*/]

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true
  host = 'localhost:3000'
  config.action_mailer.default_url_options = { :host => 'localhost:3000', protocol: 'http' }
  config.autoloader = :classic
  config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = {
  #   :user_name => '0167c44620e6e7',
  #   :password => '056d0c88ca6a54',
  #   :address => 'smtp.mailtrap.io',
  #   :domain => 'smtp.mailtrap.io',
  #   :port => '2525',
  #   :authentication => :cram_md5
  # }
  config.action_mailer.smtp_settings = {
    :user_name => Rails.application.credentials.smtp_user_name,
    :password => Rails.application.credentials.smtp_password,
    :address => "smtp.gmail.com",
    :domain => "smtp.gmail.com",
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true,
    :default_charset => "utf-8",
  }
end
