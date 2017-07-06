require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module People
  mattr_accessor :app_owner, :app_name, :default_mailer, :default_locale, :internal_id_regex, :contact_info_attributes, :protected_attributes

  def self.config
    yield self
  end

  # FIXME: Need some refactoring here.
  # Here we need to get People.rb initializer to get config values such as default_mailer
  # Problem is application.rb was loaded before initializers.
  require File.expand_path('../initializers/people', __FILE__)

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.available_locales = [:en, :fr]
    config.i18n.default_locale    = People.default_locale.to_s
    config.i18n.fallbacks         = true

    config.action_mailer.default_options = { from: People.default_mailer }

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Error pages handling
    config.exceptions_app = self.routes

    config.autoload_paths << Rails.root.join('lib')
  end
end
