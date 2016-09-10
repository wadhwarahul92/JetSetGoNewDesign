class CreateProFormaInvoices < ActiveRecord::Migration
  def change
    create_table :pro_forma_invoices do |t|
      t.string :client_name
      t.text :client_address
      t.date :invoiced_on
      t.text :itinerary_charges
      t.string :aircraft
      t.integer :number_of_seats, default: 0
      t.integer :number_of_crews, default: 0
      t.boolean :catering_included
      t.integer :accommodation_nights, default: 0
      t.datetime :deleted_at
      t.datetime :created_at,                                     null: false
      t.datetime :updated_at,                                     null: false
      t.text     :miscellaneous_charges
      t.float    :service_tax,             default: 14.0
      t.text     :handling_charges
      t.float    :discount
      t.string   :discount_unit,           default: "percentage"
      t.text     :accommodation_charges
      t.string   :special_discount_unit,   default: "percentage"
      t.float    :special_discount
      t.string   :other_tax_name
      t.float    :other_tax,               default: 0.0
      t.boolean  :show_itineraries_on_pdf, default: true
      t.float    :kkc,                     default: 0.0

      t.timestamps null: false
    end
  end
end