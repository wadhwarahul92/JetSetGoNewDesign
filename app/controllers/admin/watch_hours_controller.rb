class Admin::WatchHoursController < Admin::BaseController

	before_filter :authenticate_admin

	before_filter :set_watch_hour, only: [:edit, :update]

	def index
		@watch_hours = WatchHour.includes(:airport)
	end

	def new
		@watch_hour = WatchHour.new
	end

	def create
		 @watch_hour = WatchHour.new(watch_hour_params)
    if @watch_hour.save
      flash[:success] = 'Watch hour successfully created.'
      redirect_to action: :index
    else
      render action: :new
    end
	end

	def edit

	end

	def update
		if @watch_hour.update_attributes(watch_hour_params)
      redirect_to action: :index
    else
      render action: :edit
    end
	end

	private

	def watch_hour_params
		params.require(:watch_hour).permit(
																		:airport_id,
																		:start_at,
																		:end_at

		)
	end
	
	def set_watch_hour
		@watch_hour = WatchHour.find (params[:id])
	end

end