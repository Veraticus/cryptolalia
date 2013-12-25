require 'test_helper'

class StegnanographyTest < MiniTest::Test

  def setup
    super
    @cipher = Cryptolalia::Cipher::Steganography.new
  end

  def test_encodes_in_comments
    temp = Tempfile.new('output.png')

    @cipher.plaintext = "This was cleverly hidden in an image's comments!"
    @cipher.encoded_in = :comment
    @cipher.file = "test/fixtures/sample.png"
    @cipher.output_file = temp.path
    @cipher.encode!

    png = ChunkyPNG::Image.from_file(temp.path)
    assert_equal "This was cleverly hidden in an image's comments!", png.metadata['Comment']
  end

  def test_encodes_in_lsb
    temp = Tempfile.new('output.png')

    @cipher.plaintext = "This was cleverly hidden in an image's bits!"
    @cipher.encoded_in = :lsb
    @cipher.file = "test/fixtures/sample.png"
    @cipher.output_file = temp.path
    @cipher.encode!

    png = ChunkyPNG::Image.from_file(temp.path)
    message_bits = ''
    png.width.times do |x|
      png.height.times do |y|
        bytes = ChunkyPNG::Color.to_truecolor_alpha_bytes(png[x, y])
        bits = bytes.collect {|b| b.to_s(2).rjust(8, '0')}
        bits.each {|b| message_bits << b[-1]}
      end
    end

    message = message_bits.scan(/.{8}/).collect {|b| b.to_i(2)}.pack('c*')
    assert message =~ /^This was cleverly hidden in an image's bits!/
  end

  def test_encodes_in_two_lsbs
    temp = Tempfile.new('output.png')

    @cipher.plaintext = ''
    2000.times do
      @cipher.plaintext << "This was cleverly hidden in an image's bits! "
    end
    @cipher.encoded_in = :lsb
    @cipher.file = "test/fixtures/sample.png"
    @cipher.output_file = temp.path
    @cipher.encode!

    png = ChunkyPNG::Image.from_file(temp.path)
    message_bits = ''
    png.width.times do |x|
      png.height.times do |y|
        bytes = ChunkyPNG::Color.to_truecolor_alpha_bytes(png[x, y])
        bits = bytes.collect {|b| b.to_s(2).rjust(8, '0')}
        bits.each {|b| message_bits << b[-2]}
      end
    end

    message = message_bits.scan(/.{8}/).collect {|b| b.to_i(2)}.pack('c*')
    assert message =~ /^This was cleverly hidden in an image's bits!/
  end

  def test_decodes_comment
    temp = Tempfile.new('output.png')

    @cipher.plaintext = "This was cleverly hidden in an image's comments!"
    @cipher.encoded_in = :comment
    @cipher.file = "test/fixtures/sample.png"
    @cipher.output_file = temp.path
    @cipher.encode!

    @new_cipher = Cryptolalia::Cipher::Steganography.new
    @new_cipher.encoded_in = :comment
    @new_cipher.file = temp.path
    @new_cipher.decode!

    assert_equal "This was cleverly hidden in an image's comments!", @new_cipher.plaintext
  end

  def test_decodes_lsb
    temp = Tempfile.new('output.png')

    @cipher.plaintext = "This was cleverly hidden in an image's bits!"
    @cipher.encoded_in = :lsb
    @cipher.file = "test/fixtures/sample.png"
    @cipher.output_file = temp.path
    @cipher.encode!

    @new_cipher = Cryptolalia::Cipher::Steganography.new
    @new_cipher.encoded_in = :lsb
    @new_cipher.file = temp.path
    @new_cipher.decode!

    assert @new_cipher.plaintext =~ /^This was cleverly hidden in an image's bits!/
  end
end
