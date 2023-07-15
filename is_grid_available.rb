#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mqtt'
require 'logger'
require 'raspi-gpio'
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

red_led = GPIO.new(env('RED_LED_PIN'))
red_led.set_mode(OUT)

green_led = GPIO.new(env('GREEN_LED_PIN'))
green_led.set_mode(OUT)

client = MQTT::Client.connect(
  host: env('MQTT_HOST'),
  port: env('MQTT_PORT')
)

client.subscribe(env('MQTT_TOPIC'))
_mqtt_topic, grid_voltage = client.get
client.disconnect

@logger.info("Grid voltage: #{grid_voltage}")

if grid_voltage.to_i > env('LOW_VOLTAGE_THRESHOLD').to_i
  @logger.info('Grid appears to be available. Turning on green light.')
  red_led.set_value(LOW)
  green_led.set_value(HIGH)
else
  @logger.info('Grid does not appear to be available. Turning on red light.')
  green_led.set_value(LOW)
  red_led.set_value(HIGH)
end

@logger.debug("Red LED status: #{red_led.get_value}")
@logger.debug("Green LED status: #{green_led.get_value}")
