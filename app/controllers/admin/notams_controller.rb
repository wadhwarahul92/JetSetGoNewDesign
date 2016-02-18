class Admin::NotamsController < Admin::BaseController

  before_filter :authenticate_admin

  before_filter :set_notam, only: [:edit, :update]

  def index
    @notams = Notam.includes(:airport)
  end

  def new
    @notam = Notam.new
  end

  def create
    @notam = Notam.new(notam_params)
    if @notam.save
      flash[:success] = 'Notam created successfully'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @notam.update_attributes(notam_params)
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  private

  def notam_params
    params.require(:notam).permit(
                              :airport_id,
                              :start_at,
                              :end_at
    )
  end

  def set_notam
    @notam = Notam.find params[:id]
  end

end