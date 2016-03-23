class BackgroundJob

  def populate_watch_hours(filename)
    begin
      book = RubyXL::Parser.parse("#{Rails.root}/tmp/#{filename}")
      sheet = book.worksheets[0]
      index = 1
      row = sheet.sheet_data[index]
      WatchHour.transaction do
        while row.present? and row[0].present?
          puts row[0].value

          ######
          c = row[0].value
          airport = Airport.where(icao_code: c).first
          d = row[1].value.strftime('%d %b %Y')
          m_1 = row[2].value.strftime('%H:%M')
          m_2 = row[3].value.strftime('%H:%M')
          start_at = DateTime.parse("#{d} #{m_1}")
          end_at = DateTime.parse("#{d} #{m_2}")
          WatchHour.create!(airport_id: airport.id, start_at: start_at, end_at: end_at)
          ######

          index += 1
          row = sheet.sheet_data[index]
        end
      end
    rescue Exception => e
      ActionMailer::Base.mail(
          to: 'suraj.pratap24@gmail.com',
          subject: 'Error in BackgroundJob#populate_watch_hours',
          from: 'monika@jetsetgo.in',
          body: <<BEGIN
#{e.inspect}
index = #{index}
backtrace = #{e.backtrace}
BEGIN
      ).deliver_now
    end
  end

end