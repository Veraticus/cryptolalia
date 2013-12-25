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

end
