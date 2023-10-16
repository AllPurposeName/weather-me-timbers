class WeatherForecast
  def self.call(address:, weather_api: WeatherApi)
    new(address:, weather_api:).()
  end

  attr_reader :address, :weather_api
  def initialize(address:, weather_api:)
    @address = address
    @weather_api = weather_api
  end

  def call
    was_cached = true
    weather_api_response = WeatherApiResponse.new(Rails.cache.fetch(address.zip, expires_in: 30.minutes) do
      was_cached = false
      weather_api.get_forecast_for(address:)
    end)
    weather_api_response.was_cached = was_cached
    weather_api_response
  end
end


