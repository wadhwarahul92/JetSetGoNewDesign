class Organisations::JsgUpdatesController < Organisations::BaseController

  ######################################################################
  # Description: Index is an action which provide all the list of jetsetgo news
  # @return [Array]
  ######################################################################
  def index
    @jsg_updates = JsgUpdate.all
  end

  def last_record
    @jsg_update = JsgUpdate.last
  end

end
