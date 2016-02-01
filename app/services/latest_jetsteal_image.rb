class LatestJetstealImage

  require 'RMagick'

  def initialize
    @jetsteal = Jetsteal.ready_for_sale.last
    @canvas = Magick::ImageList.new
    @canvas.new_image(500, 50, Magick::SolidFill.new('rgb(58, 181, 127)'))
  end

  def draw

    text = Magick::Draw.new
    text.font_family = 'sans-serif'
    text.annotate(@canvas, 100, 40, 10, 10, 'Book private jet, from') do
      self.fill = 'white'
      self.font_weight = Magick::BoldWeight
      self.gravity = Magick::WestGravity
    end

    departure_city_image = Magick::Image.read(@jetsteal.departure_airport.city.image).first
    departure_city_image = departure_city_image.resize_to_fill(30)
    @canvas.composite!(departure_city_image, 140, 7, Magick::OverCompositeOp)

    arrival_city_image = Magick::Image.read(@jetsteal.arrival_airport.city.image).first
    arrival_city_image = arrival_city_image.resize_to_fit(30)
    @canvas.composite!(arrival_city_image, 200, 7, Magick::OverCompositeOp)

    text_2 = Magick::Draw.new
    text_2.font_family = 'sans-serif'
    text_2.annotate(@canvas, 15, 40, 180, 10, 'to') do
      self.fill = 'white'
      self.font_weight = Magick::BoldWeight
      self.gravity = Magick::CenterGravity
    end

    text_3 = Magick::Draw.new
    text_3.font_family = 'sans-serif'
    text_3.annotate(@canvas, 50, 12, 132, 37, @jetsteal.departure_airport.city.name) do
      self.fill = 'white'
      self.gravity = Magick::CenterGravity
      self.font_weight = Magick::BoldWeight
      self.pointsize = 8
    end

    text_4 = Magick::Draw.new
    text_4.font_family = 'sans-serif'
    text_4.annotate(@canvas, 50, 12, 194, 37, @jetsteal.arrival_airport.city.name) do
      self.fill = 'white'
      self.gravity = Magick::CenterGravity
      self.font_weight = Magick::BoldWeight
      self.pointsize = 8
    end

    text_5 = Magick::Draw.new
    text_5.font_family = 'sans-serif'
    text_5.annotate(@canvas, 100, 40, 248, 10, @jetsteal.end_at.strftime('%d %b %Y, %I:%M %p')) do
      self.fill = 'white'
      self.font_weight = Magick::BoldWeight
      self.gravity = Magick::WestGravity
    end

    if @jetsteal.sell_by_seats
      per_text = 'Per Seat'
      cost_text = "INR #{@jetsteal.min_seat_cost}"
    else
      per_text = 'Per Jet'
      cost_text = "INR #{@jetsteal.cost}"
    end

    text_5 = Magick::Draw.new
    text_5.font_family = 'sans-serif'
    text_5.annotate(@canvas, 150, 15, 398, 10, per_text) do
      self.fill = 'white'
      self.font_weight = Magick::BoldWeight
      self.gravity = Magick::WestGravity
    end

    text_5 = Magick::Draw.new
    text_5.font_family = 'sans-serif'
    text_5.annotate(@canvas, 150, 35, 398, 20, cost_text) do
      self.fill = 'white'
      self.font_weight = Magick::BoldWeight
      self.gravity = Magick::WestGravity
    end

    url = "#{Rails.root}/tmp/#{SecureRandom.urlsafe_base64}#{Time.now.to_i}.png"

    @canvas.write(url)

    url
  end

end