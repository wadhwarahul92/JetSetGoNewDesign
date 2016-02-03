class AddAccomodationToCities < ActiveRecord::Migration
  def change
    add_column :cities, :accomodation_category, :string
  end
end
