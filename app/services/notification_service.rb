class NotificationService < MobileNotificationService

  class<<self

    def new_forum_topic_added(operator, forum_topic)

        alert = "#{forum_topic.organisation.name}: #{forum_topic.statement}".truncate(250)

        data = {
            type: 1,
            id: forum_topic.id
        }

        notification(operator, alert, data)

    end

    def new_forum_topic_comment_added(operator, forum_topic_comment)

      alert = "#{forum_topic_comment.organisation.name}: #{forum_topic_comment.comment}".truncate(250)

      data = {
          type: 1,
          id: forum_topic_comment.id
      }

      notification(operator, alert, data)

    end

    def aircraft_added(operator, aircraft)

      alert = "#{aircraft.organisation.name}: Add a new aircraft #{aircraft.tail_number}".truncate(250)

      data = {
          type: 3,
          id: aircraft.id
      }

      notification(operator, alert, data)

    end

    def aircraft_edit(operator, aircraft)

      alert = "#{aircraft.organisation.name}: Edit aircraft #{aircraft.tail_number}".truncate(250)

      data = {
          type: 3,
          id: aircraft.id
      }

      notification(operator, alert, data)

    end

    def aircraft_unavailability_added(operator, aircraft_unavailability)

      alert = "#{aircraft_unavailability.aircraft.organisation.name}: New unavailability for #{aircraft_unavailability.aircraft.tail_number}".truncate(250)

      data = {
          type: 4,
          id: aircraft_unavailability.id
      }

      notification(operator, alert, data)

    end

    def aircraft_unavailability_deleted(operator, aircraft_unavailability)

      alert = "#{aircraft_unavailability.aircraft.organisation.name}: Removed unavailability for #{aircraft_unavailability.aircraft.tail_number}".truncate(250)

      data = {
          type: 4,
          id: aircraft_unavailability.id
      }

      notification(operator, alert, data)

    end

    def trip_added(operator, trip)

      alert = "#{trip.organisation.name}: Created a Trip##{trip.id}".truncate(250)

      data = {
          type: 2,
          id: trip.id
      }

      notification(operator, alert, data)

    end

    def enquiry_added(operator, trip)

      alert = "#{trip.user.full_name}: Request for Enquiry##{trip.id}".truncate(250)

      data = {
          type: 2,
          id: trip.id
      }

      notification(operator, alert, data)

    end

    def quote_created(operator, trip)

      alert = "#{trip.user.full_name}: Generated a Quote##{trip.id}".truncate(250)

      data = {
          type: 2,
          id: trip.id
      }

      notification(operator, alert, data)

    end

  end

end