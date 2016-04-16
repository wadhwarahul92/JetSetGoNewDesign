class Organisations::ForumTopicsController < Organisations::BaseController

  before_action :authenticate_operator

  before_action :set_forum_topic, only: [:show]

  def new

  end

  def index
    if request.format == 'application/json'
      @forum_topics = ForumTopic.order('created_at ASC').includes(:organisation).reverse_order
    else
      @forum_topics = ForumTopic.order('created_at ASC').includes(:organisation).reverse_order.paginate(page: params[:page], per_page: 10)
    end
  end

  def create
    @forum_topic = current_organisation.forum_topics.new(forum_topic_params.merge(operator_id: current_user.id))
    if @forum_topic.save

      ######################################################################
      # Description: Notifications
      ######################################################################
      AdminMailer.new_forum_topic(@forum_topic).deliver_later
      OrganisationMailer.new_forum_topic(@forum_topic).deliver_later
      current_organisation.operators.each { |operator| NotificationService.new_forum_topic_added(operator, @forum_topic).deliver_later }
      ######################################################################

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