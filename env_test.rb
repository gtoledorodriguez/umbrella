# /env_test.rb
require "dotenv/load"

pp ENV.fetch("PIRATE_WEATHER_API_KEY")
