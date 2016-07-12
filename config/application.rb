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

  PREVIOUS_DEF = self.instance_method :handle_failed_job

  def handle_failed_job(job, error)
    PREVIOUS_DEF.bind(self).call(job, error)
    ActionMailer::Base.mail(
                          to: 'mayur.singh@jetsetgo.in',
                          from: 'monika@jetsetgo.in',
                          subject: 'JetSetGo: Failure in background job',
                          body: <<BEGIN
job = #{job.inspect}
error = #{error.inspect}
backtrace = #{error.backtrace}
BEGIN
    ).deliver_now
  end
end
#################################