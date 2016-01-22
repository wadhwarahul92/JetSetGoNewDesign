class Admin::ModelAttributesController < Admin::BaseController

  before_action :authenticate_admin

  before_action :set_model

  before_action :set_model_instance, only: [:show]

  def index
    if params[:commit] == 'search'
      @model_instances = @model.where("#{params[:attr]}" => params[:value]).paginate(page: params[:page], per_page: 20)
    else
      @model_instances = @model.paginate(page: params[:page], per_page: 20)
    end
  end

  def show

  end

  private

  def set_model
    @model = params[:model_id].constantize
  end

  def set_model_instance
    @model_instance = @model.find(params[:id])
  end

end