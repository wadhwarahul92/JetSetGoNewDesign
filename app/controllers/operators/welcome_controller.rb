class Operators::WelcomeController < Operators::BaseController

  before_action :authenticate_operator, only: [:index]

  before_action :authenticate_no_user, only: [:log_in, :sign_up, :create_sign_in, :create_sign_up]

  def index

  end

  def log_in

  end

  def sign_up

  end

  def create_sign_in
    # noinspection RailsChecklist01
    @operator = Operator.where(email: params[:email]).first
    if @operator.present?
      # noinspection RailsChecklist01
      if @operator.valid_password?(params[:password])
        # noinspection RubyArgCount
        sign_in(@operator)
        redirect_to action: :index and return
      else
        @error = 'Email / password combination does not match'
      end
    else
      @error = 'Email / password combination does not match'
    end
    render action: :log_in
  end

  def create_sign_up

  end

end