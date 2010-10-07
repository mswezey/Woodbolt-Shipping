require 'test_helper'

class ListItemTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert ListItem.new.valid?
  end
end
