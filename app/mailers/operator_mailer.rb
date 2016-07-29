class OperatorMailer < ApplicationMailer

  layout 'operator_mailer'

  def operator_sign_up_to_operator(operator)
    @operator = operator

    mail(
        to: operator.email,
        subject: 'Welcome to JetSetGo'
    )
  end

  def forgot_password(operator, token)
    @operator = operator
    @token = token
    mail(
        to: @operator.email,
        subject: 'JetSetGo - password reset'
    )
  end

end