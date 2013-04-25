require 'json'
require 'nokogiri'
require 'addressable/uri'
require 'rest-client'
require_relative 'key.rb'


def get_current_location
	puts "Want some ice cream?"
	puts "Enter your current address:"
	address = gets.chomp
	puts "\n\nFind ice cream here:"
	puts ""

	location_query = Addressable::URI.new(
	       :scheme => "http",
	       :host => "maps.googleapis.com",
	       :path => "maps/api/geocode/json",
	       :query_values => {
	                       :address => address ? address : "770 Broadway, New York, NY",
	                       :sensor => "false"
	                      }
	                      ).to_s

	location_raw = JSON.parse(RestClient.get(location_query))

	location_raw["results"][0]["geometry"]["location"]
end

def get_nearby_shops(lat, long)
	nearby_query = Addressable::URI.new(
	       :scheme => "https",
	       :host => "maps.googleapis.com",
	       :path => "maps/api/place/nearbysearch/json",
	       :query_values => {
	                         :key => KEY,
	                         :location => "#{lat},#{long}",
	                         :rankby => "distance",
													 #:radius => "1000",
	                         :sensor => "false",
													 :keyword => "ice cream"
	                        }
	                        ).to_s

	nearby_raw = JSON.parse(RestClient.get(nearby_query))

	nearby_raw["results"]
end

def get_directions(lat, long, dest_lat, dest_long)
	directions_query = Addressable::URI.new(
       :scheme => "http",
       :host => "maps.googleapis.com",
       :path => "maps/api/directions/json",
       :query_values => {
                         :origin => "#{lat},#{long}",
    										 :destination => "#{dest_lat},#{dest_long}",
												 :sensor => "false"
                        }
                        ).to_s


	directions_raw = JSON.parse(RestClient.get(directions_query))

	directions_raw["routes"][0]["legs"][0]["steps"]
end

location = get_current_location

lat = location["lat"]
long = location["lng"]

nearby = get_nearby_shops(lat, long)

nearby.each do |shop|
	puts shop["name"]

	dest_location = shop["geometry"]["location"]
	dest_lat = dest_location["lat"]
	dest_long = dest_location["lng"]

	directions = get_directions(lat, long, dest_lat, dest_long)



	directions.each do |step|
		puts step["html_instructions"]
	end
	puts""

end

# puts lat
# puts long
