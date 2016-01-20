class JetstealSubscriptionsController < ApplicationController

  def create
    @jetsteal_subscription = JetstealSubscription.new(filtered_params)
    if @jetsteal_subscription.save
      flash[:success] = 'Thank you for subscribing.'
      redirect_to params[:redirect_to]
    else
      flash[:error] = @jetsteal_subscription.errors.full_messages.first
      redirect_to params[:redirect_to]
    end
  end

  private

  def filtered_params
    params.require(:jetsteal_subscription).permit(:email, :name, :phone)
  end

end