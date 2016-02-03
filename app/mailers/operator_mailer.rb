class OperatorMailer < ApplicationMailer

  def operator_sign_up_to_operator(operator)
    @operator = operator

    mail(
        to: operator.email,
        subject: 'Welcome to JetSetGo'
    )
  end

end