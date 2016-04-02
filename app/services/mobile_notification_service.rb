class MobileNotificationService

  class <<self

    def new_forum_topic_added

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

      end

    end
  end

end