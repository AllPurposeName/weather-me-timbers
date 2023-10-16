Rails.application.routes.draw do
  root "weather_forecasts#index"

  resources "weather_forecasts", only: [:index]
  get "up" => "rails/health#show", as: :rails_health_check
end
