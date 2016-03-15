class JetstealSubscriptionsController < ApplicationController

  protect_from_forgery except: [:create]

  def create

    @jetsteal_subscription = JetstealSubscription.new(filtered_params)
    @jetsteal_subscription.send_emails = true

    if params[:from_web].present?

      if CaptchaValidator.new(params['g-recaptcha-response'], request.remote_ip).validated!
        if @jetsteal_subscription.save
          flash[:success] = 'Thank you for subscribing.'
          redirect_to (params[:redirect_to] || '/')
        else
          flash[:error] = @jetsteal_subscription.errors.full_messages.first
          redirect_to (params[:redirect_to] || '/')
        end
      else
        flash[:error] = 'Captcha is invalid.'
        redirect_to(params[:redirect_to] || '/')
      end

    else
      ######################################################################
      # Description: FROM IOS APP
      ######################################################################
      if @jetsteal_subscription.save
        flash[:success] = 'Thank you for subscribing.'
        redirect_to (params[:redirect_to] || '/')
      else
        flash[:error] = @jetsteal_subscription.errors.full_messages.first
        redirect_to (params[:redirect_to] || '/')
      end
    end
  end

  def unsubscribe
    @jetsteal_subscription = JetstealSubscription.find(params[:id])
    @jetsteal_subscription.update_attribute(:send_emails, false)
  end

  private

  def filtered_params
    params.require(:jetsteal_subscription).permit(
        :email,
        :name,
        :phone,
        :date,
        :departure_airport,
        :arrival_airport,
        :pax
    )
  end

end