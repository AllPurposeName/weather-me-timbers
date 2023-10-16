require 'rails_helper'

RSpec.describe "Address" do
  describe "#to_url_param/0" do
    let(:city) { "commerce city" }
    let(:state) { "co" }
    let(:street) { "123 high st" }
    let(:zip) { "80022" }

    it "joins the components of the address together with url whitespace in between" do
      actual = Address.new(city:, state:, street:, zip:).to_url_param
      expected = "123%20high%20st%20commerce%20city%2080022%20co"
      expect(actual).to eq(expected)
    end
  end
end

