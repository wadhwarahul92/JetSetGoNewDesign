class CustomerNotificationService < MobileNotificationService

  class<<self

    def enquiry_added(customer, trip)

      alert = "JetSetGo: Enquiry##{trip.id} generated".truncate(250)

      data = {
          type: 2,
          id: trip.id
      }

      notification(customer, alert, data)

    end

    def quote_created(customer, trip)

      alert = "JetSetGo: Generated a Quote##{trip.id}".truncate(250)

      data = {
          type: 2,
          id: trip.id
      }

      notification(customer, alert, data)

    end

  end

end