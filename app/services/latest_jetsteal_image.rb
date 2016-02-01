class LatestJetstealImage

  require 'RMagick'

  def initialize
    @jetsteal = Jetsteal.ready_for_sale.last
    @canvas = Magick::ImageList.new
    @canvas.new_image(400, 100, Magick::SolidFill.new('rgb(58, 181, 127)'))
  end

  def draw

    text = Magick::Draw.new
    text.font_family = 'sans-serif'
    text.annotate(@canvas, 100, 50, 10+55, 10, 'Book a private jet, from') do
      self.fill = 'white'
      self.font_weight = Magick::BoldWeight
      self.gravity = Magick::WestGravity
      self.pointsize = 15
    end

    departure_city_image = Magick::Image.read(@jetsteal.departure_airport.city.image).first
    departure_city_image = departure_city_image.resize_to_fill(30)
    @canvas.composite!(departure_city_image, 180+55, 7, Magick::OverCompositeOp)

    text_3 = Magick::Draw.new
    text_3.font_family = 'sans-serif'
    text_3.annotate(@canvas, 50, 12, 174+55, 40, @jetsteal.departure_airport.city.name) do
      self.fill = 'white'
      self.gravity = Magick::CenterGravity
      self.font_weight = Magick::BoldWeight
      self.pointsize = 8
    end

    text_2 = Magick::Draw.new
    text_2.font_family = 'sans-serif'
    text_2.annotate(@canvas, 15, 50, 225+55, 10, 'to') do
      self.fill = 'white'
      self.font_weight = Magick::BoldWeight
      self.gravity = Magick::CenterGravity
      self.pointsize = 15
    end

    arrival_city_image = Magick::Image.read(@jetsteal.arrival_airport.city.image).first
    arrival_city_image = arrival_city_image.resize_to_fit(30)
    @canvas.composite!(arrival_city_image, 247+55, 7, Magick::OverCompositeOp)

    text_4 = Magick::Draw.new
    text_4.font_family = 'sans-serif'
    text_4.annotate(@canvas, 50, 12, 241+55, 40, @jetsteal.arrival_airport.city.name) do
      self.fill = 'white'
      self.gravity = Magick::CenterGravity
      self.font_weight = Magick::BoldWeight
      self.pointsize = 8
    end

    text_5 = Magick::Draw.new
    text_5.font_family = 'sans-serif'
    text_5.annotate(@canvas, 0, 0, 0, 15, @jetsteal.end_at.strftime('on %d %b %Y at %I:%M %p')) do
      self.fill = 'white'
      self.font_weight = Magick::BoldWeight
      self.gravity = Magick::CenterGravity
    end

    if @jetsteal.sell_by_seats
      cost_text = "starting @ INR #{@jetsteal.min_seat_cost}"
    else
      cost_text = "starting @ INR #{@jetsteal.cost}"
    end

    text_5 = Magick::Draw.new
    text_5.font_family = 'sans-serif'
    text_5.annotate(@canvas, 0, 0, 0, 35, cost_text) do
      self.fill = 'white'
      self.font_weight = Magick::BoldWeight
      self.gravity = Magick::CenterGravity
      self.pointsize = 15
    end

    url = "#{Rails.root}/tmp/#{SecureRandom.urlsafe_base64}#{Time.now.to_i}.png"

    @canvas.write(url)

    url
  end

end