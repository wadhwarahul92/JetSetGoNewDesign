class Organisations::WelcomeController < Organisations::BaseController

  before_action :authenticate_no_user, only: [:create, :log_in, :create_]

  before_action :authenticate_operator, only: [:index]

  def index

  end

  def create

  end

  def log_in

  end

  def create_
    @organisation = Organisation.new(organisation_params)
    if @organisation.save
      render status: :ok, json: { organisation: { id: @organisation.id } }
    else
      render status: :unprocessable_entity, json: { errors: @organisation.errors.full_messages }
    end
  end

  def setting
    params
  end

  private

  def organisation_params
    params.permit(
              :name
    )
  end

end