# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.

Rails.application.config.middleware.use ExceptionNotification::Rack,
  :email => {
    :email_prefix => "Rails ",
    :sender_address => %{"notifier" <railshw6_432673@zoho.com>},
    :exception_recipients => %w{railshw6_432673@zoho.com},
  }

Rails.application.initialize!
