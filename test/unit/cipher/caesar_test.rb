require 'test_helper'

class CaesarTest < MiniTest::Test

  def setup
    super
    @cipher = Cryptolalia::Cipher::Caesar.new
  end

  def test_encodes_with_rot_0
    @cipher.plaintext = 'This did not change at all!'
    @cipher.rot = 0
    @cipher.encode!

    assert_equal "this did not change at all", @cipher.ciphertext
  end

  def test_encodes_with_rot_13
    @cipher.plaintext = 'This did not change at all!'
    @cipher.rot = 1
    @cipher.encode!

    assert_equal "uijt eje opu dibohf bu bmm", @cipher.ciphertext
  end

  def test_decodes_with_rot_5
    @cipher.ciphertext = "ymnx ini sty hmfslj fy fqq"
    @cipher.rot = 5
    @cipher.decode!

    assert_equal "this did not change at all", @cipher.plaintext
    assert_equal 5, @cipher.rot
    assert_equal "ymnx ini sty hmfslj fy fqq", @cipher.ciphertext
  end


end
