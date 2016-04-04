class KeyValuePair < ActiveRecord::Base

  LAST_PUSH_NOTIFICATION_FEEDBACK_PROCESSED = 'last_push_notification_processed_at'

  class<<self

    def value_for_key(key)
      self.where(key: key).first.try(:value)
    end

    def last_push_notification_processed_at
      a = value_for_key(LAST_PUSH_NOTIFICATION_FEEDBACK_PROCESSED)
      a.present? ? DateTime.parse(a) : DateTime.now - 1.year
    end

  end

end