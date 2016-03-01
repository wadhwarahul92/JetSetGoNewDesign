class SearchActivity < ActiveRecord::Base

  belongs_to :search

  belongs_to :departure_airport, class_name: 'Airport', foreign_key: :departure_airport_id

  belongs_to :arrival_airport, class_name: 'Airport', foreign_key: :arrival_airport_id

  validates_presence_of :search, :departure_airport_id, :arrival_airport_id, :start_at,:pax

end