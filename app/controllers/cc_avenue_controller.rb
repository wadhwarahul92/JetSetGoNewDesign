class CcAvenueController < ApplicationController

  def initiate_request
    #This is to handle
    @jetsteal_contact_creator = JetstealContactCreator.new(
        params[:jetsteal_id],
        params[:jetsteal_seat_ids],
        params[:first_name],
        params[:last_name],
        params[:email],
        params[:phone]
    )
    if @jetsteal_contact_creator.validated_seats!
      #proceed
    else
      flash[:error] = 'Oops! looks like one of the seats you picked is already booked.'
      redirect_to "/jetsteals/#{params[:jetsteal_id]}"
    end
  end

end