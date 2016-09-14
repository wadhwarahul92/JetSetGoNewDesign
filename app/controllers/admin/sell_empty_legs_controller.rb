class Admin::SellEmptyLegsController < Admin::BaseController

  before_filter :authenticate_admin

  def index
    @activities = Activity.where(empty_leg: true, in_sale: true)
  end

end