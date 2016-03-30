class AdminMailer < ApplicationMailer

  add_template_helper(ApplicationHelper)

  default to: Admin.get_all_emails

  DEFAULT_SUBJECT = 'JetSetGo Admins - '

  layout 'admin_mailer'

  def operator_signed_up(operator)
    @operator = operator
    mail(
        to: Admin.get_all_emails,
        subject: 'Operator Sign Up Notification'
    )
  end

  def new_jetsteal(jetsteal, subscribers)
    @jetsteal = jetsteal
    @subscribers = subscribers
    mail(
        to: Admin.get_all_emails,
        subject: 'New jetsteal added'
    )
  end

  def new_organisation_and_admin_created(organisation, operator)
    @organisation = organisation
    @operator = operator
    mail(
        subject: DEFAULT_SUBJECT + 'someone created an organisation'
    )
  end

  def operator_adds_new_trip(operator, trip)
    @operator = operator
    @trip = trip
    mail(
        subject: DEFAULT_SUBJECT + 'an organisation added a new trip'
    )
  end

  def operator_added_unavailability(operator, unavailability)
    @operator = operator
    @unavailability = unavailability
    mail(
        subject: DEFAULT_SUBJECT + 'an organisation created unavailability for one of their aircrafts'
    )
  end

end