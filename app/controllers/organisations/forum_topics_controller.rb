class Organisations::ForumTopicsController < Organisations::BaseController

  before_action :authenticate_operator

  before_action :set_forum_topic, only: [:show]

  def new

  end

  def index
    @forum_topics = ForumTopic.order('created_at ASC').includes(:organisation).paginate(page: params[:page], per_page: 10)
  end

  def create
    @forum_topic = current_organisation.forum_topics.new(forum_topic_params.merge(operator_id: current_user.id))
    if @forum_topic.save
      render status: :ok, nothing: true
    else
      render status: :unprocessable_entity, json: { errors: @forum_topic.errors.full_messages }
    end
  end

  def show

  end

  private

  def set_forum_topic
    @forum_topic = ForumTopic.find params[:id]
  end

  def forum_topic_params
    params.permit(
              :statement,
              :description
    )
  end

end