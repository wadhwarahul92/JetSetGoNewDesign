class Organisations::ForumTopicCommentsController < Organisations::BaseController

  before_action :authenticate_operator

  before_action :set_forum_topic

  def create
    @forum_topic_comment = @forum_topic.forum_topic_comments.new(
        forum_topic_comment_params.merge(
                                      organisation_id: current_organisation.id,
                                      operator_id: current_user.id
        )
    )
    if @forum_topic_comment.save
      render status: :ok
    else
      render status: :unprocessable_entity, json: { errors: @forum_topic_comment.errors.full_messages }
    end
  end

  def index
    @forum_topic_comments = @forum_topic.forum_topic_comments.includes(:organisation, :operator)
  end

  private

  def set_forum_topic
    @forum_topic = ForumTopic.find params[:forum_topic_id]
  end

  def forum_topic_comment_params
    params.permit(
              :comment
    )
  end

end