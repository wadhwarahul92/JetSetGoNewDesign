namespace :data do
  desc 'This task will create airports from airports.csv'

  task seed_airports: :environment do

    airports = {}

    File.open("#{Rails.root}/lib/tasks/data/airports.csv", 'r') do |file|

      file.readlines.each do |line|

        name = line.split(',')[0].chomp

        city = line.split(',')[1].chomp

        airports[name] = city

      end

    end

    #find cities which are not in DB

    not_in_db = []

    airports.each_pair do |airport, city|

      not_in_db << city unless City.where(name: city).any?

    end

    if not_in_db.any?
      puts "Won't proceed further, some of the cities are missing."
      puts "Missing cities = #{not_in_db.to_s}"
    else
      airports.each_pair do |airport, city|

        Airport.create(
                   name: airport,
                   city_id: City.where(name: city).first.id
        )

      end
    end

  end

end