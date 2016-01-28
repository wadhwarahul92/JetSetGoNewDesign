require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JetSetGo
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'New Delhi'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.active_job.queue_adapter = :delayed_job
  end
end

#send emails to Suraj if DJ fails
Delayed::Worker.class_eval do
  def handle_failed_job_with_notification(job, error)
    env = {}
    env['exception_notifier.options'] = {
        :sections => %w(backtrace delayed_job),
        :email_prefix => '[Delayed Job ERROR] ',
        :exception_recipients => %w(suraj.pratap@jetsetgo.in),
        :sender_address => %{'notifier' <suraj.pratap@jetsetgo.in>}
    }
    env['exception_notifier.exception_data'] = {:job => job}
    # ::ExceptionNotifier::Notifier.exception_notification(env, error).deliver
    ExceptionNotifier.notify_exception(error, env: env).deliver_later
  end
end
#################################