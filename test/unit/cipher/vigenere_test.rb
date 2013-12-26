require 'test_helper'

class VigenereTest < MiniTest::Test

  def setup
    super
    @cipher = Cryptolalia::Cipher::Vigenere.new
  end

  def test_encodes
    @cipher.plaintext = 'This is a super secret message.'
    @cipher.keyword = 'qwerty'
    @cipher.encode!

    assert_equal "jdmj bq q oygxp iagixr cawjteu", @cipher.ciphertext
  end

  def test_decodes
    @cipher.ciphertext = 'jdmj bq q oygxp iagixr cawjteu'
    @cipher.keyword = 'qwerty'
    @cipher.decode!

    assert_equal "this is a super secret message", @cipher.plaintext
  end

end
