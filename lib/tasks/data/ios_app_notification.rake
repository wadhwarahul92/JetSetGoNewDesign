namespace :db do
  namespace :data do

    desc 'This creates an instance for ios_app notification service'

    task ios_app_notification_service: :environment do

      app = Rpush::Apns::App.find_by_name('ios_app')

      if app.present?

        puts 'App is already present. Cool!'

      else


        app = Rpush::Apns::App.new
        app.name = 'ios_app'
        app.certificate = File.read("#{Rails.root}/lib/certificates/iphone_app_notifications.pem")
        app.environment = 'production' # APNs environment.
        app.password = 'Vasudev123'
        app.connections = 1
        if app.save

          puts 'App successfully created. Great!'

        else

          puts app.errors.full_messages

        end

      end

    end

  end
end