class OperatorCreator

  attr_accessor :params

  attr_accessor :errors

  def initialize(params)
    @params = params
  end

  def create!

    @operator = Operator.new(
                            first_name: params[:first_name],
                            last_name: params[:last_name],
                            email: params[:email],
                            password: params[:password],
                            phone: params[:phone]
    )

    if @operator.save
      OperatorMailer.operator_sign_up_to_operator(@operator).deliver_later

    else
      # do nothing
    end

    @operator

  end

end