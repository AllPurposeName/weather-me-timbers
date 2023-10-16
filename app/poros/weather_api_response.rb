class WeatherApiResponse
  attr_accessor :current, :high, :low, :was_cached
  def initialize(parsed_response)
    @current = parsed_response["days"].first["temp"]
    @high    = parsed_response["days"].first["tempmax"]
    @low     = parsed_response["days"].first["tempmin"]
  end
end
