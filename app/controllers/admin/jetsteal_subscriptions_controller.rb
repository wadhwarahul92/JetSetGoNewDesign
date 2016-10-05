class Admin::JetstealSubscriptionsController < Admin::BaseController

  before_filter :authenticate_admin

  def index
    @jetsteal_subscriptions = JetstealSubscription.all.order(created_at: :desc).paginate(page: params[:page], per_page: 20)
  end

end