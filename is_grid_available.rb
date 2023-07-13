#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mqtt'
require 'logger'
require 'dotenv'
Dotenv.load('.env.local', '.env')

@logger = Logger.new($stdout)
@logger.level = ENV['LOG_LEVEL'].downcase.to_sym

def env(variable)
  @logger.debug("Processing environment variable: #{variable}")

  raise NameError unless ENV.include? variable
  raise NameError if ENV[variable].nil?

  @logger.debug("Environment variable value: #{ENV[variable]}")
  ENV[variable]
end

client = MQTT::Client.connect(
  host: env('MQTT_HOST'),
  port: env('MQTT_PORT')
)

client.subscribe(env('MQTT_TOPIC'))
_mqtt_topic, grid_voltage = client.get
client.disconnect

@logger.info("Grid voltage: #{grid_voltage}")

if grid_voltage.to_i > env('LOW_VOLTAGE_THRESHOLD').to_i
  # Turn on the green light
  @logger.info('Grid appears to be available. Turning on green light.')
else
  # Turn on the red light
  @logger.info('Grid does not appear to be available. Turning on red light.')
end
