require 'test_helper'

class PackingSlipTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert PackingSlip.new.valid?
  end
end
