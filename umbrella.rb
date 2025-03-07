require "http"
require "json"
require "dotenv/load"

puts "========================================\n    Will you need an umbrella today?    \n========================================"
puts "Where are you?"
#user_location = gets.chomp.gsub(" ", "%20")
user_location = "Chicago"
puts "Checking the weather at #{user_location.gsub("%20", " ")}...."

map_key = ENV.fetch("GMAPS_KEY")
pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")

map_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{map_key}"
raw_gmaps_data = HTTP.get(map_url)
parsed_gmaps_data = JSON.parse(raw_gmaps_data)
results = parsed_gmaps_data.fetch("results")
first_result = results.at(0)
geo = first_result.fetch("geometry")
location = geo.fetch("location")
latitude = location.fetch("lat")
longitude = location.fetch("lng")

puts "Your coordinates are #{latitude}, #{longitude}"

pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{latitude},#{longitude}"

raw_pirate_weather_data = HTTP.get(pirate_weather_url)
parsed_pirate_weather_data = JSON.parse(raw_pirate_weather_data)
currently = parsed_pirate_weather_data.fetch("currently")
current_temp = currently.fetch("temperature")
puts "It is currently #{current_temp}°F"

pp parsed_pirate_weather_data.keys
puts "Next hour: #{}"
