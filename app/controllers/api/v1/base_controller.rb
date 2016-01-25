class Api::V1::BaseController < ApplicationController

  def index
    render json: { version: '1.0' }
  end

end