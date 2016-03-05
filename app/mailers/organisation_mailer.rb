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
        subject: 'JetSetGo - organisation created'
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
        subject: 'JetSetGo - organisation created'
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
        subject: 'JetSetGo - organisation created'
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
        subject: 'JetSetGo - organisation created'
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
        subject: 'JetSetGo - organisation created'
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
        subject: 'JetSetGo - organisation created'
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
        subject: 'JetSetGo - organisation created'
    )
  end


end