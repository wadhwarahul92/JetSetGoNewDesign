class AddColumnToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :in_sale, :boolean, default: false
    add_column :activities, :minimum_sale_price, :float, default: 0.0
    add_column :activities, :maximum_sale_price, :float, default: 0.0
    add_column :activities, :sell_button_clicked, :boolean, default: false
  end
end
