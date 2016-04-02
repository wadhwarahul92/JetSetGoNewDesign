class MobileNotificationService

  class <<self

    ######################################################################
    # Description: This sends app notifications to all operators when a new forum topic is added
    # @param [ForumTopic] forum_topic
    ######################################################################
    def new_forum_topic_added(forum_topic)
      #send notifications to all operators
      Operator.find_each do |operator|

        alert = "#{forum_topic.organisation}: ##{forum_topic.statement}".truncate(250)

        self.new(operator).send_notification(alert, {
            type: 1,
            id: forum_topic.id
        })

      end
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