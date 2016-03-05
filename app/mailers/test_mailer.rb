class TestMailer < ApplicationMailer

  layout 'mailer_2'

  def test_layout
    mail(
        to: 'suraj.pratap@jetsetgo.in',
        subject: 'Testing mail'
    )
  end

end