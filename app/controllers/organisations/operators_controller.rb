class Organisations::OperatorsController < Organisations::BaseController

  before_action :set_organisation, except: [:log_in_]

  before_action :authenticate_no_user, only: [:admin, :create_admin, :log_in_]

  before_action :authenticate_operator, only: [:index]

  #POST
  # noinspection RailsChecklist01
  def log_in_
    @operator = Operator.where(email: params[:email]).first
    if @operator.present? and @operator.valid_password?(params[:password])
      sign_in(@operator)
      render status: :ok, nothing: true
    else
      render status: :unprocessable_entity, json: { errors: ['Email / password does not match.'] }
    end
  end

  def index

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

end