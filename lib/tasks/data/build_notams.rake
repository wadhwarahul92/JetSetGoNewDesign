namespace :db do

  desc 'build notams'

  task build_notams: :environment do

    File.open("#{Rails.root}/lib/statics/notam.txt") do |f|

      f.readlines.each do |line|

        city_name, start_at, end_at = line.split(',')

        city = City.where('lower(name) = ?', city_name.downcase).first

        if city.present?

          city.airports.each do |airport|

            Notam.create!(
                     airport_id: airport.id,
                     start_at: start_at,
                     end_at: end_at
            )

          end

        end

      end

    end

  end

end