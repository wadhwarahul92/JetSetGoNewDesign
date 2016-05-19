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

  ######################################################################
  # Description: When new aircraft created
  # @param [Aircraft] aircraft
  # @return [ActionMailer::Base]
  ######################################################################
  def new_aircraft(aircraft)
    @aircraft = aircraft
    mail(
        subject: DEFAULT_SUBJECT + 'an organisation added aircraft'
    )
  end

  ######################################################################
  # Description: When edit aircraft
  # @param [Aircraft] aircraft
  # @return [ActionMailer::Base]
  ######################################################################
  def edit_aircraft(aircraft)
    @aircraft = aircraft
    mail(
        subject: DEFAULT_SUBJECT + 'an organisation update aircraft'
    )
  end

  ######################################################################
  # Description: When add a new forum topic
  # @param [ForumTopic] forum_topic
  # @return [ActionMailer::Base]
  ######################################################################
  def new_forum_topic(forum_topic)
    @forum_topic = forum_topic
    mail(
        subject: DEFAULT_SUBJECT + 'new forum topic created'
    )
  end


  ######################################################################
  # Description: When add a new comment in forum topic
  # @param [ForumTopicComment] comment
  # @return [ActionMailer::Base]
  ######################################################################
  def new_comment_forum_topic(forum_topic_comment)
    @forum_topic_comment = forum_topic_comment
    mail(
        subject: DEFAULT_SUBJECT + 'new comment on Forum topic'
    )
  end


  ######################################################################
  # Description: When Aircraft unavailability deleted
  # @param [AircraftUnavailability] aircraft_unavailability
  # @return [ActionMailer::Base]
  ######################################################################
  def delete_aircraft_unavailability(operator, aircraft_unavailability)
    @aircraft_unavailability = aircraft_unavailability
    @operator = operator
    mail(
        subject: DEFAULT_SUBJECT + 'aircraft unavailability deleted'
    )
  end

  ######################################################################
  # Description: When trip deleted for single activity
  # @param [Trip] trip
  # @param [Operator] operator
  # @return [ActionMailer::Base]
  ######################################################################
  def delete_single_trip(operator, activity)
    @activity = activity
    @operator = operator
    mail(
        subject: DEFAULT_SUBJECT + 'trip deleted'
    )
  end

  ######################################################################
  # Description: When a new enquiry created , Enquiry is a trip where status is enquiry
  # @param [Trip] enquiry
  # @param [Operator] operator
  # @return [ActionMailer::Base]
  ######################################################################
  def new_enquiry(operator, trip)
    @trip = trip
    @operator = operator
    mail(
        subject: DEFAULT_SUBJECT + 'new enquiry created'
    )
  end

  ######################################################################
  # Description: When enquiry deleted, Enquiry is a trip where status is enquiry
  # @param [Trip] enquiry
  # @param [Operator] operator
  # @return [ActionMailer::Base]
  ######################################################################
  def delete_enquiry(operator, trip)
    @trip = trip
    @operator = operator
    mail(
        subject: DEFAULT_SUBJECT + 'delete enquiry'
    )
  end

  ######################################################################
  # Description: When a new quote created, Quote is a trip where status is quote
  # @param [Trip] quote
  # @param [Operator] operator
  # @return [ActionMailer::Base]
  ######################################################################
  def send_quote(operator, trip)
    @trip = trip
    @operator = operator
    mail(
        subject: DEFAULT_SUBJECT + 'quote created'
    )
  end

  ######################################################################
  # Description: When approved organisation by Super Admin
  # @param [Operator] operator
  # @return [ActionMailer::Base]
  ######################################################################
  def approved_organisation(organisation)
    @organisation = organisation
    mail(
        subject: DEFAULT_SUBJECT + 'approved organisation by Admin'
    )
  end

  ######################################################################
  # Description: When approved operator by Super Admin
  # @param [Operator] operator
  # @return [ActionMailer::Base]
  ######################################################################
  def approved_operator_by_admin(operator)
    @operator = operator
    mail(
        subject: DEFAULT_SUBJECT + 'approve operator by Admin'
    )
  end

  def aircraft_approved_by_admin(admin, aircraft)
    @admin = admin
    @aircraft = aircraft
    mail(
        subject: DEFAULT_SUBJECT + 'approve by Admin'
    )
  end

  def aircraft_disapproved_by_admin(admin, aircraft)
    @admin = admin
    @aircraft = aircraft
    mail(
        subject: DEFAULT_SUBJECT + 'disapprove by Admin'
    )
  end

  def create_yatra_enquiry(yatra_enquiry)
    @yatra_enquiry = yatra_enquiry
    mail(
        subject: DEFAULT_SUBJECT + 'New Yatra Enquiry Received.'
    )
  end

end