class AddColumnAccommodationPlanToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :accommodation_plan, :text
  end
end
