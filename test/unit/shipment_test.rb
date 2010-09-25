require 'test_helper'

class ShipmentTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Shipment.new.valid?
  end
end
