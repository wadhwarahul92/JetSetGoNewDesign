class CustomersController < ApplicationController

  before_action :set_customer, only: [:update_image]

  def update_image
    if @customer.update_attributes(image: params[:file])
      render status: :ok, json: { image_url: @customer.image.url(:size_250x250) }
    else
      render status: :unprocessable_entity, json: { errors: @customer.errors.full_messages }
    end
  end

  private

  def set_customer
    @customer = current_user
  end

end