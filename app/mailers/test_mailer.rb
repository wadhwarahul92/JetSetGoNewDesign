class TestMailer < ApplicationMailer

  layout 'mailer_2'

  def test_layout
    mail(
        to: 'mayur.singh@jetsetgo.in',
        subject: 'Testing mail'
    )
  end

end