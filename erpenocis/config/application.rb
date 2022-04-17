require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Erpenocis
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.active_model.i18n_customize_full_message
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: "glc27.hostico.ro",
        domain: "alexrogna.com",
        port: 465,
        ssl: true,
        authentication: :login,
      user_name: ENV.fetch("EMAIL_USER_NAME"){ 'none'},
      password: ENV.fetch("EMAIL_PSW"){ 'none'},
      enable_starttls_auto: true
    }
  end
end
