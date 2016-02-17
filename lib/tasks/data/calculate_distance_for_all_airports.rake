namespace :db do
  namespace :airports do

    desc 'This calculates distance between airports given their lat and long'

    task calculate_distance: :environment do

      Airport.all.each do |airport_1|
        Airport.all.each do |airport_2|

          distance = Distance.where(
              from_airport_id: airport_1.id,
              to_airport_id: airport_2.id
          ).first

          unless distance.present?

            if airport_1.latitude.present? and airport_1.longitude.present? and airport_2.latitude and airport_2.longitude

              d = MathHelper.to_nm(MathHelper.distance_between_lat_long( airport_1.latitude, airport_1.longitude, airport_2.latitude, airport_2.longitude))

              Distance.create(
                          from_airport_id: airport_1.id,
                          to_airport_id: airport_2.id,
                          distance_in_nm: d
              )

            end

          end

        end
      end

    end

  end
end