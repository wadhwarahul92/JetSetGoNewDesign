class Admin::EnquiriesController < Admin::BaseController

  before_action :authenticate_admin

  before_action :set_enquiry, only: [:show]

  def index
    if params[:user_full_name].present?
      @enquiries = Trip.where('lower(first_name) LIKE ? OR lower(last_name) LIKE ? ', "%#{params[:user_full_name].to_s.downcase}%", "%#{params[:user_full_name].to_s.downcase}%").all.paginate(page: params[:page], per_page: 50)
    elsif params[:user_email].present?
      @enquiries = Trip.where('lower(user_email) LIKE ? ', "%#{params[:user_email].to_s.downcase}%").all.paginate(page: params[:page], per_page: 50)
    else
      @enquiries = Trip.where(status: Trip::STATUS_ENQUIRY).order(id: :desc).all.paginate(page: params[:page], per_page: 50)
    end

  end

  def show

  end

  private

  def set_enquiry
    @enquiry = Trip.where(status: Trip::STATUS_ENQUIRY).find params[:id]
    totalFlightCostTemp = 0;
    totalCostTemp = 0;
    totalHandlingCostTemp = 0;
    totalLandingCostTemp = 0;
    taxesTemp = 0;
    swachhBharatCessTemp = 0;
    krishiKalyanTemp = 0;
    taxesTemp = 0;
    aircarft_Details = @enquiry.activities.first.aircraft
    @enquiry.activities.each do |activity|
      totalFlightCostTemp +=  activity.flight_cost + (activity.flight_cost * aircarft_Details.flight_cost_commission_in_percentage)/100;
      totalCostTemp +=  activity.flight_cost + (activity.flight_cost * aircarft_Details.flight_cost_commission_in_percentage)/100;
      totalCostTemp +=  activity.landing_cost_at_arrival + (activity.landing_cost_at_arrival * aircarft_Details.handling_cost_commission_in_percentage)/100;
      totalCostTemp +=  activity.handling_cost_at_takeoff + (activity.handling_cost_at_takeoff * aircarft_Details.handling_cost_commission_in_percentage)/100;

      totalHandlingCostTemp += activity.handling_cost_at_takeoff + (activity.handling_cost_at_takeoff * aircarft_Details.handling_cost_commission_in_percentage)/100;
      totalLandingCostTemp += activity.landing_cost_at_arrival + (activity.landing_cost_at_arrival * aircarft_Details.handling_cost_commission_in_percentage)/100;

      totalCostTemp +=  activity.watch_hour_cost

      accomodationPlan =  activity.accommodation_plan[0]

      if(accomodationPlan)
        totalCostTemp += ( accomodationPlan.cost + (accomodationPlan*aircarft_Details.accomodation_cost_commission_in_percentage)/100)
      end

    end

    totalCostTemp +=@enquiry.miscellaneous_expenses
    totalCostTemp +=( @enquiry.miscellaneous_expenses * aircarft_Details.flight_cost_commission_in_percentage)/100
    taxesTemp = (totalCostTemp * 14)/100
    swachhBharatCessTemp = (totalCostTemp * 0.5)/100
    krishiKalyanTemp = (totalCostTemp * 0.5)/100
    totalCostTemp += (totalCostTemp *15)/100

    @totalFlightCost = totalFlightCostTemp

    @totalCost = totalCostTemp

    @taxes = taxesTemp

    @SwachhBharatCess = swachhBharatCessTemp

    @KrishiKalyan = krishiKalyanTemp

    @tatalHandlingCost = totalHandlingCostTemp + totalLandingCostTemp

  end

end