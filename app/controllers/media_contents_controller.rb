class MediaContentsController < ApplicationController

  def index
    @media_contents = MediaContent.all.order('order_number asc')
  end

end