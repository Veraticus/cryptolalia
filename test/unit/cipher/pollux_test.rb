require 'test_helper'

class PolluxTest < MiniTest::Test

  def setup
    super
    @cipher = Cryptolalia::Cipher::Pollux.new
  end

  def test_encodes_with_random_alphabet
    @cipher.plaintext = 'This message is now Morse encoded.'
    @cipher.encode!

    message = ''
    current_character = ''
    @cipher.ciphertext.split('').each do |char|
      if @cipher.dot.include?(char)
        current_character << '.'
      elsif @cipher.dash.include?(char)
        current_character << '-'
      else
        message << Cryptolalia::Cipher::Pollux::MORSE_ALPHABET.invert[current_character].to_s
        current_character = ''
      end
    end

    assert_equal 'thismessageisnowmorseencoded', message
  end

  def test_decode
    @cipher.ciphertext = "1.accc.ba.caa,13!c,acb.acc.b2!21a!a,ab!acb.1b,333!a12.11.311.c3c,cbc,b!c!2c,2a1a!223.2ab!c!2cb,"
    @cipher.dot = ["a", "b", "c"]
    @cipher.dash = ["1", "2", "3"]
    @cipher.seperator = ["!", ".", ","]
    @cipher.decode!

    assert_equal 'thismessageisnowmorseencoded', @cipher.plaintext
  end

end
