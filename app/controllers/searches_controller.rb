class SearchesController < ApplicationController

  def create
    @search = Search.create
    @search_activities = []
    params[:activities].each do |activity|
      @search_activities << @search.search_activities.new(activity.permit(
          :departure_airport_id,
          :arrival_airport_id,
          :start_at,
          :pax
      ))
    end

    @error = nil
    @search_activities.each do |search_activity|
      unless search_activity.valid?
        @error = search_activity.errors.full_messages.first
      end
    end

    # noinspection RubyResolve
    if @error.present?
      render status: :unprocessable_entity, json: { errors: [@error] }
    else
      @search_activities.map(&:save)
      render status: :ok, json: { search_id: @search.id }
    end
  end

  def show
    if request.format == 'text/html'
      render template: 'welcome/index', layout: 'application'
    elsif request.format == 'application/json'
      @results = SearchAlgorithm.new(params[:id]).results.first(40)
      @airport_break_ups = SearchAlgorithm.new(params[:id]).airport_break_ups
      @search_activities  = SearchAlgorithm.new(params[:id]).search_activities
      render status: :ok
    end
  end

  def get_for_index
    @search = Search.find params[:id]
    @search_activities = @search.search_activities
  end

end