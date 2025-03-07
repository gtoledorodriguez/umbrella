require "http"
require "json"
require "dotenv/load"

puts "========================================\n    Will you need an umbrella today?    \n========================================"
puts "Where are you?"
user_location = gets.chomp.gsub(" ", "%20")
#user_location = "Chicago"
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

minutely = parsed_pirate_weather_data.fetch("minutely")
next_hour_summary = minutely.fetch("summary")
puts "Next hour: #{next_hour_summary}"

hourly = parsed_pirate_weather_data.fetch("hourly")
hourly_data_array = hourly.fetch("data")
next_twelve_hours = hourly_data_array[1..12]
precip_prob_threshold = 0.2
umbrella = false

next_twelve_hours.each do |hour|
  precip_prob = hour.fetch("precipProbability")
  if precip_prob >= precip_prob_threshold
    umbrella = true

    time = hour.fetch("time")
    precip_hour = Time.at(time).hour
    current_hour = Time.now.hour
    hours_from_now = precip_hour - current_hour

    precip_percent = (precip_prob*100).round
    puts "In #{hours_from_now} hours, there is a #{precip_percent}% chance of precipitation."
  end
end

if umbrella
  puts "You might want to take an umbrella!"
else
  puts "You probrably won't need an umbrella"
end
