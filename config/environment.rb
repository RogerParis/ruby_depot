# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

Depot::Application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 995,
    domain: "gmail.com",
    authentication: "plain",
    user_name: "roger.paris@njiuko.com",
    password: "anousauzoi11",
    enable_starttls_auto: true
  }
end
