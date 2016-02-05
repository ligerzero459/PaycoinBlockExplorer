require File.expand_path('../boot', __FILE__)

# require 'rails/all'
require 'action_controller/railtie'

require 'action_mailer/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PaycoinBlockExplorer
  class Application < Rails::Application
    config.assets.paths << Rails.root.join("vendor", "assets", "fonts", "images")
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.sequel.after_connect = proc do
      Sequel::Model.db.extension :pagination

      Sequel::Model.plugin :active_model
      Sequel::Model.plugin :validation_helpers
      Sequel::Model.plugin :dirty
      Sequel::Model.plugin :association_proxies
      Sequel::Model.plugin :json_serializer
    end

    config.assets.precompile << Proc.new { |path, fn| fn =~ /vendor\/assets/ && %w(.js .css .jpg .png).include?(File.extname(path)) }

    require Rails.root.join("lib/custom_public_exceptions")
    config.exceptions_app = CustomPublicExceptions.new(Rails.public_path)
  end
end
