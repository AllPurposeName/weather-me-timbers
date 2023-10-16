class Address
  include ActiveModel::Model
  attr_reader :city, :state, :street, :zip
  def initialize(city:'', state:'', street:'', zip:'')
    @city = city
    @state = state
    @street = street
    @zip = zip
  end

  def to_url_param
    [street.split, city.split, zip, state].flatten.join("%20")
  end
end
