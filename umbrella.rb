require "http"
require "json"
require "dotenv/load"

puts "========================================\n    Will you need an umbrella today?    \n========================================"
puts "Where are you?"
loc = gets.chomp
puts loc

map_key = ENV.fetch("GMAPS_KEY")
pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")

map_url = "https://maps.googleapis.com/maps/api/geocode/json?address="+loc+"&key="+map_key
raw_gmaps_data = HTTP.get(map_url)
parsed_gmaps_data = JSON.parse(raw_gmaps_data)
print parsed_gmaps_data
# pirate_weather_url = "https://api.pirateweather.net/forecast/"+pirate_weather_key+"/"+latitude+","+longitude
