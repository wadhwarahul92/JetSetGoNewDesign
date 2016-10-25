class Admin::EnquiriesController < Admin::BaseController

  before_action :authenticate_admin

  before_action :set_enquiry, only: [:show]

  def index
    @enquiries = Trip.where(status: Trip::STATUS_ENQUIRY).order(id: :desc).all.paginate(page: params[:page], per_page: 50)

  end

  def show

  end

  private

  def set_enquiry
    @enquiry = Trip.where(status: Trip::STATUS_ENQUIRY).find params[:id]

    totalCostTemp = 0;

    aircarft_Details = @enquiry.activities.first.aircraft


    # count = @enquiry.activities.length




    @enquiry.activities.each do |activity|

      totalCostTemp +=  activity.flight_cost + (activity.flight_cost * aircarft_Details.flight_cost_commission_in_percentage)/100;
      totalCostTemp +=  activity.landing_cost_at_arrival + (activity.landing_cost_at_arrival * aircarft_Details.handling_cost_commission_in_percentage)/100;
      totalCostTemp +=  activity.handling_cost_at_takeoff + (activity.handling_cost_at_takeoff * aircarft_Details.handling_cost_commission_in_percentage)/100;
      totalCostTemp +=  activity.watch_hour_cost

      accomodationPlan =  activity.accommodation_plan[0]

      if(accomodationPlan)
        totalCostTemp += ( accomodationPlan.cost + (accomodationPlan*aircarft_Details.accomodation_cost_commission_in_percentage)/100)
      end

    end

    totalCostTemp +=@enquiry.miscellaneous_expenses
    totalCostTemp +=( @enquiry.miscellaneous_expenses * aircarft_Details.flight_cost_commission_in_percentage)/100
    totalCostTemp += (totalCostTemp *15)/100



    # (0..count).each do |i|
    #
    #   myActivity =  @enquiries.activities[i];
    #
    # end




    @totalCost = totalCostTemp


  end

end