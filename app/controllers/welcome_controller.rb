class WelcomeController < ApplicationController

  def index
    # redirect_to '/jetsteals/list'
  end

  def tmp_index
    render action: :index
  end

  def tmp_message_send

    if params[:phone].present? and params[:text].present?
      array = params[:phone]
      msg = params[:text]
      for phone in array
       # response =  HTTParty.get('http://bhashsms.com/api/sendmsg.php', params: {user: 'ravikataria', pass: '123', sender: 'BYEBUY', phone: "#{phone}", text: "#{msg}", priority: 'ndnd', style: 'normal'})
       # response =  HTTP.get('http://bhashsms.com/api/sendmsg.php', params: {user: 'ravikataria', pass: '123', sender: 'BYEBUY', phone: "#{phone}", text: "#{msg}", priority: 'ndnd', style: 'normal'})
       SmsDelivery.new(phone, msg).deliver
      end
      render status: :ok, nothing: true
    else
      render status: :unprocessable_entity, nothing: true
    end
  end

  def current_user_
    if current_user.present?
      # @count_empty_legs = count_empty_legs
      render status: :ok
    else
      render status: :unprocessable_entity, nothing: true
    end
  end

  # noinspection RailsChecklist01
  def sign_in_
    @user = User.where(email: params[:email]).first
    if @user.present? and @user.valid_password?(params[:password])
      sign_in(@user)
      render action: :current_user_
    else
      render status: :unprocessable_entity, json: { errors: ['Email / Password combination wrong.'] }
    end
  end

  def sign_out_
    sign_out(current_user)
    render status: :ok, nothing: true
  end

  def sign_up_

    ######################################################################
    # Description: Verify captcha
    ######################################################################
    unless from_mobile?
      render status: :unprocessable_entity, json: { errors: ['Captcha is invalid.'] } and return unless CaptchaValidator.new(params[:captcha], request.remote_ip).validated!
    end
    ######################################################################

    @user = User.new(user_params)
    if @user.save
      @user.update_attribute(:api_token, SecureRandom.urlsafe_base64(32))
      sign_in(@user)
      CustomerMailer.sign_up(@user).deliver_later
      AdminMailer.customer_sign_up(@user).deliver_later
      SmsDelivery.new(@user.phone, SmsTemplates.customer_sign_up('JetSetGo', 'www.jetsetgo.in')).delay.deliver
      render action: :current_user_
    else
      render status: :unprocessable_entity, json: { errors: @user.errors.full_messages }
    end
  end

  def create_contact
    @contact = ContactDetail.new(contact_params)
    if @contact.save
      AdminMailer.contact_us(@contact).deliver_later
      render status: :ok, nothing: true
    else
      render status: :unprocessable_entity, json: { errors: @contact.errors.full_messages }
    end

  end

  def forgot_password_
    @user = User.where(email: params[:email]).first
    if @user.present?
      raw, token = Devise.token_generator.generate(User, :reset_password_token)

      ######################################################################
      # Description: Destroying api token whenever user does forgot password
      ######################################################################
      if @user.update_attributes(
          reset_password_token: token,
          reset_password_sent_at: Time.now.utc,
          api_token: nil
      )
        # OperatorMailer.forgot_password(@user, raw).deliver_later
        CustomerMailer.forgot_password(@user, raw).deliver_later
        render status: :ok, nothing: true
      else
        render status: :unprocessable_entity, json: {errors: @user.errors.full_messages}
      end
    else
      render status: :unprocessable_entity, json: {errors: ['Email not registered.']}
    end
  end

  def update_device_token

    case params[:type]
      when 'ios'

        if current_user.update_attributes(ios_app_devise_token: params[:device_token], send_app_notifications: true)
          render status: :ok, nothing: true
        else
          render status: :unprocessable_entity, json: { errors: current_user.errors.full_messages }
        end

      when 'android'

        if current_user.update_attributes(android_app_devise_token: params[:device_token], send_app_notifications: true)
          render status: :ok, nothing: true
        else
          render status: :unprocessable_entity, json: { errors: current_user.errors.full_messages }
        end

      else
        render status: :unprocessable_entity, json: { errors: ['type is not specified'] }
    end

  end

  def get_passenger_datails
    @trip = current_user.trips.includes(:activities, :passenger_details).find params[:id]
    @passenger_details = @trip.passenger_details
  end

  def our_fleet
    if request.format == 'text/html'
      render template: 'templates/our_fleet', layout: 'application'
    elsif request.format == 'application/json'
      aircraft_type_ids = AircraftType.where(aircraft_category_id: params[:id]).map(&:id)
      @aircrafts = Aircraft.where(is_jsg_fleet: true,aircraft_type_id: aircraft_type_ids).includes(:aircraft_images, :aircraft_type, :base_airport )
      render status: :ok
    end
  end

  private

  def user_params
    params.permit(
              :first_name,
              # :last_name,
              :email,
              :password,
              :phone
    )
  end

  def contact_params
    params.permit(
        :name,
        :email,
        :phone,
        :message
    )
  end

  # def count_empty_legs
  #   count = 0
  #   trip_ids = current_user.trips.map(&:id)
  #   count = Activity.where(trip_id: trip_ids, empty_leg: true).count
  #
  #   jetsteals = nil
  #   contact = Contact.where(email: current_user.email).first
  #   if contact.present?
  #     jetsteal_ids = contact.payment_transactions.where(status: 'success', is_jetsteal: true).map(&:jetsteal_id)
  #     jetsteals = Jetsteal.where(id: jetsteal_ids)
  #     count = count + jetsteals.count
  #   end
  #   count
  # end

end