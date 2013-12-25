require 'test_helper'

class BealeTest < MiniTest::Test

  def setup
    super
    @cipher = Cryptolalia::Cipher::Beale.new
  end

  def test_encodes_by_first_word_in_file
    @cipher.plaintext = 'tdi usa'
    @cipher.only_first_word = true
    @cipher.file = "test/fixtures/Declaration\ of\ Independence.txt"
    @cipher.encode!

    assert_equal "1 3 12 2 8 10", @cipher.ciphertext
  end

  def test_encodes_by_file
    @cipher.plaintext = 'Hello, darling.'
    @cipher.file = "test/fixtures/Declaration\ of\ Independence.txt"
    @cipher.encode!

    cleaned_plaintext = @cipher.cleaned_plaintext.gsub(/\s/, '')
    words = @cipher.source_text.split(' ')

    @cipher.ciphertext.split(' ').each_with_index do |number, index|
      assert_equal cleaned_plaintext[index], words[number.to_i - 1].downcase[0], "error at index #{index}: looking for #{cleaned_plaintext[index]} at word #{number.to_i - 1} (#{words[number.to_i - 1]})"
    end
  end

  def test_decodes_by_file
    @cipher.ciphertext = "158 1101 921 799 1063 1009 1005 1260 747 366 205 582 201 1213 13 94 652 649"
    @cipher.file = "test/fixtures/Declaration\ of\ Independence.txt"
    @cipher.decode!

    assert_equal 'thisisabiglongtest', @cipher.plaintext
  end

  def text_source_text_cleans_regular_text
    assert @cipher.source_text !~ /[,\.]/
  end

end
