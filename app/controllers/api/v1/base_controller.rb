class Api::V1::BaseController < ApplicationController

  def index
    render json: { version: '1.0' }
  end

  def raise_support
    HelpMailer.support_ticket(params[:name], params[:email], params[:message]).deliver_later
  end

end