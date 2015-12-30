class JetstealMailer < ApplicationMailer

  def test_mailer
    mail to: 'suraj.pratap@jetsetgo.in',
         subject: 'Test to see mails are actually running'
  end

end