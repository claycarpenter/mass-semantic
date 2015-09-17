require File.expand_path('../boot', __FILE__)

require 'rails/all'
# require 'recursive-open-struct'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Update environment variables with values in application config file.
ENV.update YAML.load_file('config/application.yml')[Rails.env] rescue {}

module MassSemantic
  class Settings
    # Inspired by:
    # http://blog.carbonfive.com/2011/11/23/configuration-for-rails-the-right-way/#comment-4215
    def load(file_path)
      raw_config = File.read(file_path)
      erb_config = ERB.new(raw_config).result
      config_hash = YAML.load(erb_config)[Rails.env]
      config = RecursiveOpenStruct.new(config_hash, :recurse_over_arrays => true)
    end
  end

  class Application < Rails::Application
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
    config.active_record.raise_in_transactional_callbacks = true

    # Load configuration
    settings = MassSemantic::Settings.new

    # FIXME This will probably break in a different environment.
    config.app_config = settings.load("config/application.yml")
  end
end
