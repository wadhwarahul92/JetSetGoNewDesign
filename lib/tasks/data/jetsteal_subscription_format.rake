namespace :db do
  namespace :data do
    desc 'This will put all id where name is added from api'
    task subscription_format_id: :environment do
      JetstealSubscription.find_each do |subscription|
        to_save = false

        departure_airport = Airport.where(name: subscription.departure_airport).first
        if departure_airport.present?
          subscription.departure_airport = departure_airport.id.to_s
          to_save = true
        end

        arrival_airport = Airport.where(name: subscription.arrival_airport).first
        if arrival_airport.present?
          subscription.arrival_airport = arrival_airport.id.to_s
          to_save = true
        end

        if to_save
          subscription.save
        end
      end
    end
  end
end