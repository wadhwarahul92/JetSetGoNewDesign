class LatestJetstealImage

  #todo optimise this to search for image of that jetsteal first and return it, if present. This will save lots of processing

  require 'rmagick'

  def initialize
    @jetsteal = Jetsteal.ready_for_sale.last
    @canvas = Magick::ImageList.new
    @canvas.new_image(400, 110, Magick::SolidFill.new('rgb(58, 181, 127)'))
    top_image = Magick::Image.read('http://d3tfanr7troppj.cloudfront.net/static_files/images/000/000/039/original/private-jet-img.png?1454329216').first
    @canvas.composite!(top_image, 0, 0, Magick::OverCompositeOp)
  end

  def draw(cache = true)

    # unless @jetsteal.present?
      tmp = rand(1..5)
      return "#{Rails.root}/app/assets/images/#{tmp}.jpg"
    # end

    ##############################
    # Check if jetsteal is sold out
    ##############################
    # l = @jetsteal
    # if l.sell_by_seats?
    #   a = l.jetsteal_seats.map{ |s|  s.locked? or s.disabled? or s.booked? }
    #   unless a.index(false)
    #     # final << l
    #     l.sold_out = true
    #   end
    # else
    #   a = l.jetsteal_seats.map{ |s| s.booked? }
    #   if a.index(true)
    #     # final << l
    #     l.sold_out = true
    #   end
    # end
    # if l.sold_out
    #   url = "#{Rails.root}/tmp/single_pixel_image.png"
    #   return url if File.file?(url)
    #   canvas = Magick::ImageList.new
    #   canvas.new_image(1, 1)
    #   canvas.write(url)
    #   return url
    # end
    #################################


    url = "#{Rails.root}/tmp/jetsteal_popularity_footer#{@jetsteal.id}.png"

    return url if File.file?(url) if cache

    text = Magick::Draw.new
    text.font_family = 'sans-serif'
    text.annotate(@canvas, 10, 10, 10, 50, 'From:') do
      self.fill = 'white'
      self.font_weight = Magick::BoldWeight
      self.gravity = Magick::WestGravity
      self.pointsize = 15
    end

    departure_city_image = Magick::Image.read(@jetsteal.departure_airport.city.image.to_s.gsub('https', 'http')).first
    departure_city_image = departure_city_image.resize_to_fill(30)
    @canvas.composite!(departure_city_image, 60, 35, Magick::OverCompositeOp)

    text_3 = Magick::Draw.new
    text_3.font_family = 'sans-serif'
    text_3.annotate(@canvas, 50, 12, 50, 70, @jetsteal.departure_airport.city.name) do
      self.fill = 'white'
      self.gravity = Magick::CenterGravity
      self.font_weight = Magick::BoldWeight
      self.pointsize = 8
    end

    text_2 = Magick::Draw.new
    text_2.font_family = 'sans-serif'
    text_2.annotate(@canvas, 10, 10, 100, 50, 'To:') do
      self.fill = 'white'
      self.font_weight = Magick::BoldWeight
      self.gravity = Magick::WestGravity
      self.pointsize = 15
    end

    if @jetsteal.sell_by_seats?

      text_2 = Magick::Draw.new
      text_2.font_family = 'sans-serif'
      text_2.annotate(@canvas, 10, 10, 180, 50, @jetsteal.end_at.strftime('On: %d %b %Y, At: %I:%M %p')) do
        self.fill = 'white'
        self.font_weight = Magick::BoldWeight
        self.gravity = Magick::WestGravity
        self.pointsize = 15
      end

    else

      text_2 = Magick::Draw.new
      text_2.font_family = 'sans-serif'
      text_2.annotate(@canvas, 10, 10, 180, 50, @jetsteal.end_at.strftime('On: %d %b %Y, Any Time')) do
        self.fill = 'white'
        self.font_weight = Magick::BoldWeight
        self.gravity = Magick::WestGravity
        self.pointsize = 15
      end

    end

    arrival_city_image = Magick::Image.read(@jetsteal.arrival_airport.city.image.to_s.gsub('https', 'http')).first
    arrival_city_image = arrival_city_image.resize_to_fit(30)
    @canvas.composite!(arrival_city_image, 130, 35, Magick::OverCompositeOp)

    text_4 = Magick::Draw.new
    text_4.font_family = 'sans-serif'
    text_4.annotate(@canvas, 50, 12, 130, 70, @jetsteal.arrival_airport.city.name) do
      self.fill = 'white'
      self.gravity = Magick::WestGravity
      self.font_weight = Magick::BoldWeight
      self.pointsize = 8
    end

    if @jetsteal.sell_by_seats
      cost_text = "#{@jetsteal.min_seat_cost}"
    else
      cost_text = "#{@jetsteal.cost}"
    end

    text_4 = Magick::Draw.new
    text_4.font_family = 'sans-serif'
    text_4.annotate(@canvas, 400, 12, 0, 91, "Starting @ INR #{to_indian_format cost_text}") do
      self.fill = 'rgb(13, 60, 124)'
      self.gravity = Magick::CenterGravity
      self.font_weight = Magick::BoldWeight
      self.pointsize = 15
    end

    @canvas.write(url)

    url
  end

  # @param [Integer] number
  # @return [String]
  def to_indian_format(number)
    number = number.to_i.to_s
    formatted_number = []
    number.split('').reverse.each_with_index do |char, index|
      if index < 3
        formatted_number << char
        next
      end
      if index == 3
        # noinspection RubyResolve
        formatted_number << ','
        formatted_number << char
        next
      end
      if index % 2 == 0
        formatted_number << char
        # noinspection RubyResolve
        formatted_number << ','
      else
        formatted_number << char
      end
    end
    formatted_number = formatted_number.reverse
    formatted_number.shift if formatted_number[0] == ','
    formatted_number.join
  end

end