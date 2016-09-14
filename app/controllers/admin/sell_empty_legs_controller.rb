class Admin::SellEmptyLegsController < Admin::BaseController

  before_filter :authenticate_admin

  before_action :set_activity, only: [:show]

  def index
    @activities = Activity.where(empty_leg: true, in_sale: true).order(start_at: :desc)
  end

  def show

  end

  private

  def set_activity
    @activity = Activity.find params[:id]
  end

end