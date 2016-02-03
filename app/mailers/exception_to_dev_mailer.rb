class ExceptionToDevMailer < ApplicationMailer

  def exception_in_background_job(job, error)
    @job = job
    @error = error
    mail(
        to: 'suraj.pratap@jetstego.in',
        subject: 'Exception in background processing, JETSETGO'
    )
  end

end