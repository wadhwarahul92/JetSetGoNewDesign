class Admin::CustomersController < Admin::BaseController

  before_filter :authenticate_admin

  def index

    if params[:full_name].present?
      @customers = User.where('lower(first_name) LIKE ? OR lower(last_name) LIKE ?', "%#{params[:full_name].to_s.downcase}%","%#{params[:full_name].to_s.downcase}%").paginate(page: params[:page], per_page: 25)
    elsif params[:email].present?
      @customers = User.where('lower(email) LIKE ? ', "%#{params[:email].to_s.downcase}%").paginate(page: params[:page], per_page: 25)
    elsif params[:phone].present?
      @customers = User.where(phone: params[:phone]).paginate(page: params[:page], per_page: 25)
    else
      @customers = User.where("type is null").order(id: :desc).paginate(page: params[:page], per_page: 25)
    end
  end

end