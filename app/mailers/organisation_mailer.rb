class OrganisationMailer < ApplicationMailer

  add_template_helper(ApplicationHelper)

  layout 'mailer_2'

  ######################################################################
  # Description: When organisation and operator are successfully created
  # @param [Operator] operator
  # @return [ActionMailer::Base]
  ######################################################################
  def organisation_and_operator_created(operator)
    @operator = operator
    @organisation = operator.organisation
    mail(
        to: @operator.email,
        subject: 'JetSetGo - New organisation created'
    )
  end

  ######################################################################
  # Description: When new aircraft created
  # @param [Aircraft] aircraft
  # @param [Operator] operator
  # @return [ActionMailer::Base]
  ######################################################################

  def new_aircraft(aircraft)
    @aircraft = aircraft
    @emails = Organisation.get_all_emails(aircraft.organisation)
    mail(
        to: (@emails),
        subject: 'JetSetGo - New aircraft created'
    )
  end

  ######################################################################
  # Description: When edit aircraft
  # @param [Aircraft] aircraft
  # @param [Operator] operator
  # @return [ActionMailer::Base]
  ######################################################################
  def edit_aircraft(aircraft)
    @aircraft = aircraft
    @emails = Organisation.get_all_emails(aircraft.organisation)
    mail(
        to: @emails,
        subject: 'JetSetGo - Aircraft Edit'
    )
  end

  ######################################################################
  # Description: When aircraft approved by super Admin
  # @param [Aircraft] aircraft
  # @param [Operator] operator
  # @return [ActionMailer::Base]
  ######################################################################
  def aircraft_approved_by_super_admin(aircraft)
    @aircraft = aircraft
    @emails = Organisation.get_all_emails(aircraft.organisation)
    mail(
        to: @emails,
        subject: 'JetSetGo - Aircraft approved by Admin'
    )
  end

  def aircraft_disapproved_by_super_admin(aircraft)
    @aircraft = aircraft
    @emails = Organisation.get_all_emails(aircraft.organisation)
    mail(
        to: @emails,
        subject: 'JetSetGo - Aircraft approved by Admin'
    )
  end


  ######################################################################
  # Description: When add a new forum topic
  # @param [ForumTopic] forum_topic
  # @return [ActionMailer::Base]
  ######################################################################
  def new_forum_topic(forum_topic)
    @forum_topic = forum_topic
    @emails = Organisation.get_all_emails(forum_topic.organisation)
    mail(
        to: @emails,
        subject: 'JetSetGo - New forum topic created'
    )
  end

  ######################################################################
  # Description: When add a new comment in forum topic
  # @param [ForumTopicComment] comment
  # @return [ActionMailer::Base]
  ######################################################################
  def new_comment_forum_topic(forum_topic_comment)
    @forum_topic_comment = forum_topic_comment
    @emails = Organisation.get_all_emails(forum_topic_comment.organisation)
    mail(
        to: @emails,
        subject: 'JetSetGo - New comment on Forum topic'
    )
  end

  ######################################################################
  # Description: When a new Aircraft unavailability created
  # @param [AircraftUnavailability] aircraft_unavailability
  # @return [ActionMailer::Base]
  ######################################################################
  def new_aircraft_unavailability(operator, aircraft_unavailability)
    @aircraft_unavailability = aircraft_unavailability
    @operator = operator
    @emails = Organisation.get_all_emails(aircraft_unavailability.aircraft.organisation)
    mail(
        to: @emails,
        subject: 'JetSetGo - New aircraft unavailability created'
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
    @emails = Organisation.get_all_emails(aircraft_unavailability.aircraft.organisation)
    mail(
        to: @emails,
        subject: 'JetSetGo - Aircraft unavailability deleted'
    )
  end

  ######################################################################
  # Description: When a new trip created
  # @param [Trip] trip
  # @param [Operator] operator
  # @return [ActionMailer::Base]
  ######################################################################
  def new_trip(operator, trip)
    @trip = trip
    @operator = operator
    @emails = Organisation.get_all_emails(trip.organisation)
    mail(
        to: @emails,
        subject: 'JetSetGo - New Trip created'
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
    @emails = Organisation.get_all_emails(activity.trip.organisation)
    mail(
        to: @emails,
        subject: 'JetSetGo - Trip deleted'
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
    @emails = Organisation.get_all_emails(trip.organisation)
    mail(
        to: @emails,
        subject: 'JetSetGo - New enquiry created'
    )
  end

  ######################################################################
  # Description: When enquiry Edit, Enquiry is a trip where status is enquiry
  # @param [Trip] enquiry
  # @param [Operator] operator
  # @return [ActionMailer::Base]
  ######################################################################
  def edit_enquiry(enquiry, operator)
    @enquiry = enquiry
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - Edit Enquiry'
    )
  end

  ######################################################################
  # Description: When enquiry deleted, Enquiry is a trip where status is enquiry
  # @param [Trip] enquiry
  # @param [Operator] operator
  # @return [ActionMailer::Base]
  ######################################################################
  def delete_enquiry(enquiry, operator)
    @enquiry = enquiry
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - Delete Enquiry'
    )
  end

  ######################################################################
  # Description: When a new quote created, Quote is a trip where status is quote
  # @param [Trip] quote
  # @param [Operator] operator
  # @return [ActionMailer::Base]
  ######################################################################
  def new_quote(quote, operator)
    @quote = quote
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - New enquiry created'
    )
  end

  ######################################################################
  # Description: When quote Edit, Quote is a trip where status is quote
  # @param [Trip] quote
  # @param [Operator] operator
  # @return [ActionMailer::Base]
  ######################################################################
  def edit_quote(quote, operator)
    @quote = quote
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - Edit quote'
    )
  end

  ######################################################################
  # Description: When quote deleted, Quote is a trip where status is quote
  # @param [Trip] quote
  # @param [Operator] operator
  # @return [ActionMailer::Base]
  # ######################################################################
  def delete_quote(quote, operator)
    @quote = quote
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - Delete quote'
    )
  end

  ######################################################################
  # Description: When approved organisation by Super Admin
  # @param [Operator] operator
  # @return [ActionMailer::Base]
  ######################################################################
  def approved_organisation(operator)
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - Approved organisation by Admin'
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
        to: @operator.email,
        subject: 'JetSetGo - Approve operator by Admin'
    )
  end

  ######################################################################
  # Description: When Admin set roles of an operator
  # @param [Operator] operator
  # @return [ActionMailer::Base]
  ######################################################################
  def set_roles_of_operator(operator)
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - Admin set your role'
    )
  end

end