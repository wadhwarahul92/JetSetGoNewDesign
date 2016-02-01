class LatestJetstealImage

  #todo optimise this to search for image of that jetsteal first and return it, if present. This will save lots of processing

  require 'RMagick'

  def initialize
    @jetsteal = Jetsteal.ready_for_sale.last
    @canvas = Magick::ImageList.new
    @canvas.new_image(400, 110, Magick::SolidFill.new('rgb(58, 181, 127)'))
    top_image = Magick::Image.read('http://d3tfanr7troppj.cloudfront.net/static_files/images/000/000/038/original/private-jet-img.png?1454328396').first
    @canvas.composite!(top_image, 0, 0, Magick::OverCompositeOp)
  end

  def draw

    text = Magick::Draw.new
    text.font_family = 'sans-serif'
    text.annotate(@canvas, 10, 10, 10, 50, 'From:') do
      self.fill = 'white'
      self.font_weight = Magick::BoldWeight
      self.gravity = Magick::WestGravity
      self.pointsize = 15
    end

    departure_city_image = Magick::Image.read(@jetsteal.departure_airport.city.image).first
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

    text_2 = Magick::Draw.new
    text_2.font_family = 'sans-serif'
    text_2.annotate(@canvas, 10, 10, 180, 50, @jetsteal.end_at.strftime('On: %d %b %Y At: %I:%M %p')) do
      self.fill = 'white'
      self.font_weight = Magick::BoldWeight
      self.gravity = Magick::WestGravity
      self.pointsize = 15
    end

    arrival_city_image = Magick::Image.read(@jetsteal.arrival_airport.city.image).first
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
    text_4.annotate(@canvas, 50, 12, 224, 93, cost_text) do
      self.fill = 'rgb(13, 60, 124)'
      self.gravity = Magick::WestGravity
      self.font_weight = Magick::BoldWeight
      self.pointsize = 15
    end

    url = "#{Rails.root}/tmp/#{SecureRandom.urlsafe_base64}#{Time.now.to_i}.png"

    @canvas.write(url)

    url
  end

end