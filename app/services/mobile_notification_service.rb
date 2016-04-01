class MobileNotificationService

  # @param [User] user
  def initialize(user)
    @user = user
  end

  def send_notification(alert)
    if @user.send_app_notifications?

      if @user.ios_app_devise_token.present?

        n = Rpush::Apns::Notification.new
        n.app = Rpush::Apns::App.find_by_name('ios_app')
        n.device_token = @user.ios_app_devise_token
        n.alert = alert
        # n.data = { foo: :bar }
        n.save!

        Rpush.push
        Rpush.apns_feedback

      end

    end
  end

end