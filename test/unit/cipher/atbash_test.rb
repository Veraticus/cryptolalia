require 'test_helper'

class AtbashTest < MiniTest::Test

  def setup
    super
    @cipher = Cryptolalia::Cipher::Atbash.new
  end

  def test_encodes
    @cipher.plaintext = 'This did not change at all!'
    @cipher.encode!

    assert_equal "gsrh wrw mlg xszmtv zg zoo", @cipher.ciphertext
  end

end
