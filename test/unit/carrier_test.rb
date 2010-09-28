require 'test_helper'

class CarrierTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Carrier.new.valid?
  end
end
