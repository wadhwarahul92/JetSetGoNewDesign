class Organisations::OperatorsController < Organisations::BaseController

  before_action :set_organisation, except: [:log_in_, :index, :edit, :update]

  before_action :set_operator, only: [:edit, :update]

  before_action :authenticate_no_user, only: [:admin, :create_admin, :log_in_]

  before_action :authenticate_operator, only: [:index, :edit, :update]

  #POST
  # noinspection RailsChecklist01
  def log_in_
    @operator = Operator.where(email: params[:email]).first
    if @operator.present? and @operator.valid_password?(params[:password]) and @operator.update_attribute(:api_token, SecureRandom.urlsafe_base64)
      sign_in(@operator)
      render status: :ok, json: { api_token: @operator.api_token }
    else
      render status: :unprocessable_entity, json: { errors: ['Email / password does not match.'] }
    end
  end

  def index
    @operators = current_user.organisation.operators
  end

  def edit

  end

  def update
    if @operator.update_attributes(operator_params)
      render status: :ok, nothing: true
    else
      render status: :unprocessable_entity, json: { errors: @operator.errors.full_messages }
    end
  end

  def admin

  end

  def create_admin
    if @organisation.has_admin?
      render status: :unprocessable_entity, json: { errors: ['This organisation is owned by someone.'] }
    else
      @operator = @organisation.operators.new(
          params.permit(
              :first_name,
              :last_name,
              :email,
              :phone,
              :password
          ).merge(roles: ['admin'])
      )
      if @operator.save
        sign_in(@operator)
        render status: :ok, nothing: true
      else
        render status: :unprocessable_entity, json: { errors: @operator.errors.full_messages }
      end
    end
  end

  private

  def set_organisation
    @organisation = Organisation.find params[:organisation_id]
  end

  def set_operator
    @operator = current_user.organisation.operators.find params[:id]
  end

  def operator_params
    params.permit(
              :roles
    )
  end

end