class PasswordsController < Devise::PasswordsController

  def edit
    super
    render layout: 'jetsteals'
  end

end