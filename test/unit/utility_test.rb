require 'test_helper'

class UtilityTest < MiniTest::Test

  def test_random_utf8
    assert_equal 1, Cryptolalia::Utility.random_utf8.bytesize
  end

end
