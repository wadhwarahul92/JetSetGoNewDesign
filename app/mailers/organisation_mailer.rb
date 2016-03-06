class OrganisationMailer < ApplicationMailer

  layout 'mailer_2'

  ######################################################################
  # Description: When organisation and operator are successfully created
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
 ######################################################################
  def new_aircraft(aircraft, operator)
    @aircraft = aircraft
    @organisation = aircraft.organisation
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - New aircraft created'
    )
  end

  ######################################################################
  # Description: When an aircraft deleted
  ######################################################################
  def delete_aircraft(aircraft, operator)
    @aircraft = aircraft
    @organisation = aircraft.organisation
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - Aircraft Deleted'
    )
  end

  ######################################################################
  # Description: When edit aircraft
  ######################################################################
  def edit_aircraft(aircraft, operator)
    @aircraft = aircraft
    @organisation = aircraft.organisation
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - Aircraft Edit'
    )
  end

  ######################################################################
  # Description: When aircraft approved by super Admin
  ######################################################################
  def aircraft_approved_by_super_admin(aircraft, operator)
    @aircraft = aircraft
    @organisation = aircraft.organisation
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - Aircraft approved by Admin'
    )
  end

  ######################################################################
  # Description: When add a new forum topic
  ######################################################################
  def new_forum_topic(forum_topic, operator)
    @forum_topic = forum_topic
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - New forum topic created'
    )
  end

  ######################################################################
  # Description: When add a new comment in forum topic
  ######################################################################
  def new_comment_forum_topic(comment, operator)
    @comment = comment
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - New comment on Forum topic'
    )
  end

  # On add Aircraft unavailability
  # On edit Aircraft unavailability
  # On delete Aircraft unavailability
  #
  # On add Trip
  # On edit Trip
  # On delete Trip
  #
  # On Create Enquiry
  # On Edit Enquiry
  # On Delete Enquiry
  #
  # On Quote
  # On Edit Quote
  # On Delete Quote
  #
  # On Approved Organisation by Admin
  # On Approved Operator by Admin
  # On Set Roles of Operator

  ######################################################################
  # Description: When a new Aircraft unavailability created
  ######################################################################
  def new_aircraft_unavailability(aircraft_unavailability, operator)
    @aircraft_unavailability = aircraft_unavailability
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - New aircraft unavailability created'
    )
  end

  ######################################################################
  # Description: When Aircraft unavailability Edit
  ######################################################################
  def edit_aircraft_unavailability(aircraft_unavailability, operator)
    @aircraft_unavailability = aircraft_unavailability
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - Aircraft unavailability Edit'
    )
  end

  ######################################################################
  # Description: When Aircraft unavailability deleted
  ######################################################################
  def delete_aircraft_unavailability(aircraft_unavailability, operator)
    @aircraft_unavailability = aircraft_unavailability
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - Aircraft unavailability deleted'
    )
  end

  ######################################################################
  # Description: When a new trip created
  ######################################################################
  def new_trip(trip, operator)
    @trip = trip
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - New Trip created'
    )
  end

  ######################################################################
  # Description: When trip Edit
  ######################################################################
  def edit_trip(trip, operator)
    @trip = trip
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - Edit Trip'
    )
  end

  ######################################################################
  # Description: When trip deleted
  ######################################################################
  def delete_trip(trip, operator)
    @trip = trip
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - Trip deleted'
    )
  end

  ######################################################################
  # Description: When a new enquiry created
  ######################################################################
  def new_enquiry(enquiry, operator)
    @enquiry = enquiry
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - New enquiry created'
    )
  end

  ######################################################################
  # Description: When enquiry Edit
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
  # Description: When enquiry deleted
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
  # Description: When a new quote created
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
  # Description: When quote Edit
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
  # Description: When quote deleted
  ######################################################################
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
  ######################################################################
  def set_roles_of_operator(operator)
    @operator = operator
    mail(
        to: @operator.email,
        subject: 'JetSetGo - Admin set your role'
    )
  end

end