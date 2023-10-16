require 'rails_helper'

RSpec.describe "WeatherForecast" do
  subject { WeatherForecast.(address:, weather_api:) }
  describe "#call/0" do
    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
    let(:zip) { "00501" }

    before do
      allow(Rails).to receive(:cache).and_return(memory_store)
    end
    after { Rails.cache.clear }

    let(:api_response) do
      {
        "days" => [
          {
            "temp" => 123,
            "tempmax" => 123,
            "tempmin" => 123,
          }
        ]
      }
    end
    let(:weather_api) { double("WeatherApi", get_forecast_for: api_response) }
    let(:address) { double("Address", zip: zip) }


    context "given that the cache is unpopulated" do
      it "calls the weather api" do
        weather_api.should_receive(:get_forecast_for).once.and_return(api_response)
        subject
      end

      context "was_cached" do
        it "set to false" do
          weather_api_response = subject
          expect(weather_api_response.was_cached).to be(false)
        end
      end

      context "a failed call" do
        let(:weather_api) { double("WeatherApi", get_forecast_for: proc { raise WeatherApi::APIError }) }
        it "does not set the cache" do
          weather_api.should_receive(:get_forecast_for).once.and_raise(WeatherApi::APIError)
          expect { subject }.to raise_error(WeatherApi::APIError)
          expect(memory_store.exist?(zip)).to be(false)
        end
      end
    end

    context "given that the cache is populated" do
      let!(:warm_cache) { subject }

      it "does a cache lookup" do
        weather_api.should_not_receive(:order)
        expect(subject).to eq(warm_cache)
      end

      context "was_cached" do
        it "set to true" do
          weather_api_response = WeatherForecast.(address:, weather_api:)
          expect(weather_api_response.was_cached).to be(true)
        end
      end
    end
  end
end
