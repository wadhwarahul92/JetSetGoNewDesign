class WatchHour < ActiveRecord::Base

  belongs_to :airport

  validates :airport_id, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true

  validate def end_date_after_start_date
    if self.start_at.present? && self.end_at.present? && self.start_at >= self.end_at
      self.errors.add(:end_at, 'must come after Start time')
    end
  end

  def cost
    # rand(10000..50000)
    0
  end

  def self.import(file)
    workbook = RubyXL::Parser.parse("/Users/mayursingh/Desktop/Watchhour.xlsx")
    worksheet = workbook[0]
    airports = Airport.all

    worksheet.each_with_index { |row, index|

      airport_id = nil
      start_at = nil
      end_at = nil

      tmp_date = nil

      d = ''

      row && row.cells.each_with_index { |cell, index|
        val = cell && cell.value

        # next if val = 'Airport ICAO Code' || 'Date' || 'Start time' || 'End Time'

        if index == 0
          if airports.detect{ |x| x.icao_code == val.to_s }.present?
            airport_id = airports.detect{ |x| x.icao_code == val.to_s }.id
          else
            airport_id = 0
          end

        end

        if index == 1
          tmp_date = val.to_s.to_datetime.strftime('%d/%m/%Y')
        end

        if index == 2
          start_at = tmp_date + ' ' + val.strftime('%I:%M %p')
        end

        if index == 3
          end_at = tmp_date + ' ' + val.strftime('%I:%M %p')
        end

      }

      if airport_id.present? and start_at.present? and end_at.present? and tmp_date.present?
        WatchHour.create(airport_id: airport_id,
                         start_at: start_at.to_datetime,
                         end_at: end_at.to_datetime)
      end

    }
  end

end
