class MediaContentsController < ApplicationController

  def index
    @media_contents = MediaContent.all.order('created_at desc')
  end

end