class Admin::MediaContentsController < Admin::BaseController

  before_action :authenticate_admin

  before_action :set_media_content, only: [:edit, :update, :destroy]

  def index
    @media_contents = MediaContent.all
  end

  def new
    @media_content = MediaContent.new
  end

  def create
    @media_content = MediaContent.new(media_content_params)
    if @media_content.save
      flash[:success] = 'Successfully created.'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @media_content.update_attributes(media_content_params)
      flash[:success] = 'Successfully updated'
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def destroy
    @media_content.destroy
    redirect_to action: :index
  end

  private

  def set_media_content
    @media_content = MediaContent.find params[:id]
  end

  def media_content_params
    params.require(:media_content).permit(:one_liner,
                                          :description,
                                          :image_url,
                                          :redirect_url)
  end



end