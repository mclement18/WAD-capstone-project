require 'google_maps_service'

GoogleMapsService.configure do |config|
  config.key = ENV["GOOGLE_API_SERVER_KEY"]
end

::Gmaps = GoogleMapsService::Client.new
