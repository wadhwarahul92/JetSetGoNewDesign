class Organisations::JsgUpdatesController < Organisations::BaseController

  ######################################################################
  # Description: Index is an action which provide all the list of jetsetgo news
  # @return [JsgUpdate] @jsg_updates
  ######################################################################
  def index
    @jsg_updates = JsgUpdate.all
  end

end