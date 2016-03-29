class Organisations::OperatorsController < Organisations::BaseController

  before_action :set_organisation, except: [:log_in_,
                                            :index,
                                            :edit,
                                            :new,
                                            :create,
                                            :update,
                                            :forgot_password,
                                            :forgot_password_,
                                            :profile,
                                            :profile,
                                            :toggle,
                                            :set_terms_and_condition,
                                            :get_terms_and_condition
  ]

  before_action :set_operator, only: [:edit, :update]

  before_action :authenticate_no_user, only: [:admin,
                                              :create_admin,
                                              :log_in_,
                                              :forgot_password,
                                              :forgot_password_
  ]

  before_action :authenticate_operator, only: [:index, :edit, :update, :toggle, :profile]

  protect_from_forgery except: [:log_in_]

  #POST
  # noinspection RailsChecklist01
  def log_in_
    @operator = Operator.where(email: params[:email]).first
    if @operator.present? and @operator.valid_password?(params[:password])
      @operator.update_attribute(:api_token, SecureRandom.urlsafe_base64) if @operator.api_token.blank?
      sign_in(@operator)
      render status: :ok, json: { api_token: @operator.api_token, user_id: @operator.id, organisation_id: @operator.organisation_id }
    else
      render status: :unprocessable_entity, json: { errors: ['Email / password does not match.'] }
    end
  end

  def index
    @operators = current_user.organisation.operators.where.not(id: current_user.id)
  end

  def new

  end

  def create
    @operator = Operator.new(operator_params)
    if @operator.save
      render status: :ok, nothing: true
    else
      render status: :unprocessable_entity, json: { errors: @operator.errors.full_messages }
    end
  end

  def edit

  end

  def forgot_password

  end

  # noinspection RailsChecklist01
  def forgot_password_
    @operator = Operator.where(email: params[:email]).first
    if @operator.present?
      raw, token = Devise.token_generator.generate(Operator, :reset_password_token)

      ######################################################################
      # Description: Destroying api token whenever user does forgot password
      ######################################################################
      if @operator.update_attributes(
          reset_password_token: token,
          reset_password_sent_at: Time.now.utc,
          api_token: nil
      )
        OperatorMailer.forgot_password(@operator, raw).deliver_now
        render status: :ok, nothing: true
      else
        render status: :unprocessable_entity, json: {errors: @operator.errors.full_messages}
      end
    else
      render status: :unprocessable_entity, json: {errors: ['Email not registered.']}
    end
  end

  def update
    if @operator.update_attributes(operator_role_params)
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
          ).merge(roles: ['admin'], designation: 'admin')
      )
      if @operator.save
        sign_in(@operator)
        render status: :ok, nothing: true
      else
        render status: :unprocessable_entity, json: { errors: @operator.errors.full_messages }
      end
    end
  end

  def profile
    @operator = Operator.find current_user.id
    render layout: "organisations"
  end

  def update_profile
    1
  end

  def toggle
    @operator = Operator.with_deleted.find params[:id]
    if @operator.organisation_id == current_organisation.id
      if @operator.deleted_at.present?
        @operator.update_attribute(:deleted_at, nil)
      else
        @operator.destroy
      end
      render status: :ok, nothing: true
    else
      render status: :unprocessable_entity, json: { errors: ['Unauthorised action.'] }
    end
  end

  def set_terms_and_condition
    @organisation = current_organisation
    if current_organisation.update_attributes(terms_and_condition: params[:t_and_c])
      render status: :ok, nothing: true
    else
      render status: :unprocessable_entity, json: { errors: @organisation.errors.full_messages }
    end
  end

  def get_terms_and_condition
    @organisation = current_organisation
  end

  private

  def set_organisation
    @organisation = Organisation.find params[:organisation_id]
  end

  def set_operator
    @operator = current_user.organisation.operators.find params[:id]
  end

  def operator_role_params
    params.permit(
              roles: []
    )
  end

  def operator_params
    params.permit(:first_name,
                  :last_name,
                  :designation,
                  :phone,
                  :email,
                  :password
    ).merge(organisation_id: current_user.organisation.id)
  end

end