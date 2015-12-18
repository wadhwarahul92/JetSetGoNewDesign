namespace :data do

  desc 'This task loads all cities listed in cities.csv and create entries in database'

  task seed_cities: :environment do

    File.open(File.join(File.dirname(__FILE__), 'cities.csv'), 'r') do |f|
      f.readlines.each do |line|
        name = line.split(',')[0].chomp
        state = line.split(',')[1].chomp
        City.create(
                name: name,
                state: state
        )
      end
    end

  end

end