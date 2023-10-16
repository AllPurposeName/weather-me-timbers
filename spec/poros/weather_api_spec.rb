require 'rails_helper'

RSpec.describe "WeatherApi" do
  include ActiveSupport::Testing::TimeHelpers
  describe "#get_forecast/0" do
    let(:city) { "commerce city" }
    let(:state) { "co" }
    let(:street) { "123 high st" }
    let(:zip) { "80022" }
    let(:address) { Address.new(city:, state:, street:, zip:) }
    let(:date) { "2023-01-25" }
    let(:clean_address) { "123%20high%20st%20commerce%20city%2080022%20co" }
    let(:key) { Rails.application.credentials.dig(:weather_api_key) }

    before do
      travel_to(Time.parse(date))
    end
    context "when the api call succeeds" do
      let(:http_client) { double("HTTParty", get: OpenStruct.new({success?: true})) }
      let(:expected_url) { "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/#{clean_address}/#{date}/#{date}?key=#{key}&contentType=json&unitGroup=us" }
      it "calls the correct weather url" do

        expect(http_client).to receive(:get).with(expected_url)
        WeatherApi.get_forecast_for(address:, http_client:)
      end
    end

    context "when the api call fails" do
      let(:http_client) { double("HTTParty", get: OpenStruct.new({success?: false})) }
      it "raises an error" do
        expect do
          WeatherApi.get_forecast_for(address:, http_client:)
        end.to raise_error(WeatherApi::APIError)
      end
    end
  end
end


