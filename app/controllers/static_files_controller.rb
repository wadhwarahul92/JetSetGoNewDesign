class StaticFilesController < ApplicationController

  before_action :authenticate_user!

  def create
    @static_file = StaticFile.new(file: params[:file])
    if @static_file.save
      render status: :ok
    else
      render status: :unprocessable_entity, json: {errors: @static_file.errors.full_messages}
    end
  end

end