class Admin::OperatorsController < Admin::BaseController
	before_filter :authenticate_admin

	before_filter :set_operator, only: [:edit, :update]

	def index
		@operators = Operator.all
	end

	def edit
	
	end

	def update
		@operator.update_attribute(:approved_by_admin, params[:approved_by_admin])
		redirect_to action: :index
	end

	private

	def set_operator
    @operator = Operator.find params[:id]
  end

end
