namespace :db do

  desc 'This will add tier info to cities, will override data'

  task populate_tier: :environment do

    #tier_1 are populated manually, always

    tier_2 = [
        'Agra',
        'Ajmer',
        'Aligarh',
        'Allahabad',
        'Amravati',
        'Amritsar',
        'Asansol',
        'Aurangabad',
        'Bareilly',
        'Belgaum',
        'Bhavnagar',
        'Bhiwandi',
        'Bhopal',
        'Bhubaneswar',
        'Bikaner',
        'Bokaro Steel City',
        'Chandigarh',
        'Coimbatore',
        'Cuttack',
        'Dehradun',
        'Dhanbad',
        'Durg-Bhilai Nagar',
        'Durgapur',
        'Erode',
        'Faridabad',
        'Firozabad',
        'Ghaziabad',
        'Gorakhpur',
        'Gulbarga',
        'Guntur',
        'Gurgaon',
        'Guwahati',
        'Gwalior',
        'Hubli-Dharwad',
        'Indore',
        'Jabalpur',
        'Jaipur',
        'Jalandhar',
        'Jammu',
        'Jamnagar',
        'Jamshedpur',
        'Jhansi',
        'Jodhpur',
        'Kannur',
        'Kanpur',
        'Kakinada',
        'Kochi',
        'Kolhapur',
        'Kollam',
        'Kota',
        'Kozhikode',
        'Lucknow',
        'Ludhiana',
        'Madurai',
        'Malappuram',
        'Malegaon',
        'Mangalore',
        'Meerut',
        'Moradabad',
        'Mysore',
        'Nagpur',
        'Nashik',
        'Nellore',
        'Noida',
        'Patna',
        'Pondicherry',
        'Raipur',
        'Rajkot',
        'Rajahmundry',
        'Ranchi',
        'Rourkela',
        'Salem',
        'Sangli',
        'Siliguri',
        'Solapur',
        'Srinagar',
        'Surat',
        'Thiruvananthapuram',
        'Thrissur',
        'Tiruchirappalli',
        'Tiruppur',
        'Tirupati',
        'Ujjain',
        'Vadodara',
        'Varanasi',
        'Vasai-Virar City',
        'Vijayawada',
        'Visakhapatnam',
        'Warangal'
    ]

    tier_2.each do |name|
      city = City.where(name: name).first
      puts name unless city.present?
      if city.present?
        city.update_attribute(:accomodation_category, 'tier2')
      end
    end

  end

end