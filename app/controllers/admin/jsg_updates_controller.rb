class Admin::JsgUpdatesController < Admin::BaseController

  before_filter :authenticate_admin

  before_filter :set_jsg_update, only: [:edit, :update, :show, :destroy]

  def index
    @jsg_updates = JsgUpdate.all
  end

  def new
    @jsg_update = JsgUpdate.new
  end

  def create
    @jsg_update = JsgUpdate.new(jsg_update_params)
    if @jsg_update.save
      flash[:success] = 'Jsg update successfully created.'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @jsg_update.update_attributes(jsg_update_params)
      flash[:success] = 'Successfully updated'
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def destroy

  end

  private

  def set_jsg_update
    @jsg_update = JsgUpdate.find params[:id]
  end

  def jsg_update_params
    params.require(:jsg_update).permit(
                                   :title,
                                   :description,
                                   :source_url,
                                   :image_url
    )
  end

end