class YatraEnquiriesController < ApplicationController

  def create
    @yatra_enquiry = YatraEnquiry.new(yatra_enquiry_params)
    if @yatra_enquiry.save
      render status: :ok, nothing: :true
    else
      render status: :unprocessable_entity, json: { errors: @yatra_enquiry.errors.first.full_messages }
    end
  end

  private

  def yatra_enquiry_params
    params.require(:enquiry).permit(:name,
                                    :email,
                                    :date_of_travel,
                                    :package,
                                    :mobile_number)
  end



end