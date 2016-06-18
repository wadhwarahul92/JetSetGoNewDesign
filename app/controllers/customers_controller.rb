class CustomersController < ApplicationController

  before_action :set_customer, only: [:update_image, :update_profile]

  def update_image
    if @customer.update_attributes(image: params[:file])
      render status: :ok, json: { image_url: @customer.image.url(:size_250x250) }
    else
      render status: :unprocessable_entity, json: { errors: @customer.errors.full_messages }
    end
  end

  def update_profile
    if @customer.update_attributes(phone: params[:phone])
      render status: :ok, nothing: true
    else
      render status: :unprocessable_entity, json: { errors: @customer.errors.full_messages }
    end
  end

  def booked_jets
    1
  end

  private

  def set_customer
    @customer = current_user
  end

end