namespace :data do

  desc 'This task loads all cities listed in cities.csv and create entries in database'

  task seed_cities: :environment do

    File.open(File.join(File.dirname(__FILE__), 'cities.csv'), 'r') do |f|
      f.readlines.each do |line|
        name = line.split(',')[0].chomp
        state = line.split(',')[1].chomp
        city = City.create(
                name: name,
                state: state
        )
        if city.errors.any?
          puts city.errors.full_messages.first
        end
      end
    end

  end

end