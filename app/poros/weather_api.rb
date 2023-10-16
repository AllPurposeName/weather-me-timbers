class WeatherApi
  APIError = Class.new(StandardError)
  BASE_URL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline"
  WEATHER_API_KEY = Rails.application.credentials.dig(:weather_api_key)

  def self.get_forecast_for(address:, http_client: HTTParty)
    new(address:, http_client:).get_forecast
  end

  attr_reader :address, :http_client
  def initialize(address:, http_client:)
    @address = address
    @http_client = http_client
  end

  def get_forecast
    response = http_client.get(get_forecast_url)

    if response.success?
      response.parsed_response
    else
      raise APIError
    end
  end

  private

  def get_forecast_url
    "#{BASE_URL}/#{address.to_url_param}/#{today_date_range}?key=#{WEATHER_API_KEY}&contentType=json&unitGroup=us"
  end

  def today_date_range
    "#{today}/#{today}"
  end

  def today
    @today ||= DateTime.now.strftime("%Y-%m-%d")
  end
end

