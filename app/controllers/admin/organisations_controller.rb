class Admin::OrganisationsController < Admin::BaseController
  before_filter :authenticate_admin

  before_filter :set_organisation, only: [:edit, :update]

  def index
    if params[:name].present?
      @organisations = Organisation.where('name LIKE ?', "%#{params[:name]}%")
    else
      @organisations = Organisation.all
    end
  end

  def edit

  end

  def update
    @organisation.update_attribute(:admin_verified, params[:admin_verified])
    redirect_to action: :index
  end

  private

  def set_organisation
    @organisation = Organisation.find params[:id]
  end

end
