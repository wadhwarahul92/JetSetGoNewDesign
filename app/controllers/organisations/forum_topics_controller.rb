class Organisations::ForumTopicsController < Organisations::BaseController

  before_action :authenticate_operator

  def new

  end

  def index
    @forum_topics = ForumTopic.paginate(page: params[:page], per_page: 20)
  end

end