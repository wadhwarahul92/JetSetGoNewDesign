class AircraftImageResizerJob < ActiveJob::Base
  queue_as :default

  def perform(aircraft_image)

  end
end
