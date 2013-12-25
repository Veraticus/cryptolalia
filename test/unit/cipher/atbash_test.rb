require 'test_helper'

class AtbashTest < MiniTest::Test

  def setup
    super
    @cipher = Cryptolalia::Cipher::Atbash.new
  end

  def test_encodes
    @cipher.plaintext = 'This did not change at all!'
    @cipher.ciphertext = nil
    @cipher.encode!

    assert_equal "gsrh wrw mlg xszmtv zg zoo", @cipher.ciphertext
  end

  def test_decodes
    @cipher.plaintext = nil
    @cipher.ciphertext = "gsrh wrw mlg xszmtv zg zoo"
    @cipher.decode!

    assert_equal 'this did not change at all', @cipher.plaintext
  end

end
