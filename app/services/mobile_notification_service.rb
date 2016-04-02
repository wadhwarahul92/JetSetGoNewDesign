class MobileNotificationService

  class <<self

    def notification(user, alert, data)

      hash = {
          user: user,
          alert: alert,
          data: data
      }

      hash.singleton_class.class_eval do

        def deliver_later

          MobileNotificationService.new(self[:user]).delay.send_notification(self[:alert], self[:data])

        end

      end

      hash

    end

  end

  # @param [User] user
  def initialize(user)
    @user = user
  end

  def send_notification(alert, data = {})
    if @user.send_app_notifications?

      if @user.ios_app_devise_token.present?

        n = Rpush::Apns::Notification.new
        n.app = Rpush::Apns::App.find_by_name('ios_app')
        n.device_token = @user.ios_app_devise_token
        n.alert = alert
        n.data = data
        n.save!

        Rpush.push
        Rpush.apns_feedback

      end

    end
  end

end