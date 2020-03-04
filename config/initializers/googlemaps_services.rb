require 'googlemaps/services/client'
require 'googlemaps/services/directions'

include GoogleMaps::Services

gmaps_client = GoogleClient.new key: ENV["GOOGLE_API_SERVER_KEY"], response_format: :json

::GmapsDirections = Directions.new gmaps_client
