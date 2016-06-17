class WelcomeController < ApplicationController

  def index
    redirect_to '/jetsteals/list'
  end

  def tmp_index
    render action: :index
  end

  def current_user_
    if current_user.present?
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
      render action: :current_user_
    else
      render status: :unprocessable_entity, json: { errors: @user.errors.full_messages }
    end
  end

  def create_contact
    @contact = ContactDetail.new(contact_params)
    if @contact.save
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
        OperatorMailer.forgot_password(@user, raw).deliver_later
        render status: :ok, nothing: true
      else
        render status: :unprocessable_entity, json: {errors: @user.errors.full_messages}
      end
    else
      render status: :unprocessable_entity, json: {errors: ['Email not registered.']}
    end
  end

  private

  def user_params
    params.permit(
              :first_name,
              :last_name,
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

end