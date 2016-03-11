class Organisations::TemplatesController < Organisations::BaseController

  before_action :authenticate_operator

  layout false

  def quote

  end

end