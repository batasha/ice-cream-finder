require 'json'
require 'nokogiri'
require 'addressable/uri'
require 'rest-client'
#require 'key.rb'

# google searech nearby
# https://maps.googleapis.com/maps/api/place/textsearch/json?

# google geocoding
# http://maps.googleapis.com/maps/api/geocode/output?parameters

#
# location = JSON.parse()
#


location_raw_data = Addressable::URI.new(
       :scheme => "http",
       :host => "maps.googleapis.com",
       :path => "maps/api/geocode/json",
       :query_values => {
                         :address => "770 Broadway, New York, NY",
                         :sensor => "false"
                        }
                        ).to_s

geocode_hash = JSON.parse(RestClient.get(location_raw_data))

location = geocode_hash["results"][0]["geometry"]["location"]
lat = location["lat"]
long = location["lng"]

query = Addressable::URI.new(
       :scheme => "https",
       :host => "maps.googleapis.com",
       :path => "maps/api/place/nearbysearch/json",
       :query_values => {
                         :key => "AIzaSyCXyL5FbFXq6--2Y_P4IXwySG9E7UIlRt4",
                         :location => "#{lat},#{long}",
                         :rankby => "distance",
												 #:radius => "1000",
                         :sensor => "false",
												 :keyword => "ice cream"
                        }
                        ).to_s

nearby_raw_data = JSON.parse(RestClient.get(query))

nearby_shops = nearby_raw_data["results"]


nearby_shops.each do |shop|
	puts shop["name"]
	dest_location = shop["geometry"]["location"]
	dest_lat = dest_location["lat"]
	dest_long = dest_location["lng"]

	puts ""

directions_raw = Addressable::URI.new(
       :scheme => "http",
       :host => "maps.googleapis.com",
       :path => "maps/api/directions/json",
       :query_values => {
                         :origin => "#{lat},#{long}",
    										 :destination => "#{dest_lat},#{dest_long}",
												 :sensor => "false"
                        }
                        ).to_s

directions = JSON.parse(RestClient.get(directions_raw))
puts directions

end

# puts lat
# puts long
