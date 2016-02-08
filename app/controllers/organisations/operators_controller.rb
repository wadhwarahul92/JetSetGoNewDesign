class Organisations::OperatorsController < Organisations::BaseController

  before_action :set_organisation

  before_action :authenticate_no_user, only: [:admin, :create_admin]

  def index

  end

  def admin

  end

  def create_admin
    if @organisation.has_admin?
      render status: :unprocessable_entity, json: { errors: ['This organisation is owned by someone.'] }
    else
      @operator = @organisation.operators.new(params.permit(
                                         :first_name,
                                         :last_name,
                                         :email,
                                         :phone,
                                         :password
      ))
      @operator.roles = ['admin']
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