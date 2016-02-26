class WelcomeController < ApplicationController

  def index

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
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)
      render action: :current_user_
    else
      render status: :unprocessable_entity, json: { errors: @user.errors.full_messages }
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

end