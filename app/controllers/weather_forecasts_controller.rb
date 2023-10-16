class WeatherForecastsController < ApplicationController

  def index
    @address = Address.new(**address_params.to_h.symbolize_keys)
    @forecast = WeatherForecast.(address: @address)
    if @forecast.was_cached
      flash.now[:info] = "This result was retrieved from the cache!"
    else
      flash.now[:alert] = "The cache was set!"
    end
  rescue WeatherApi::APIError
    @forecast = NullWeatherForecast.new
    flash.now[:alert] = "Something went wrong!\nMake sure your address is correct!"
  ensure
    render :index
  end

  def address_params
    params.require(:address).permit(
      :city,
      :state,
      :street,
      :zip
    )
  end
end
