require 'tempfile'
require 'oily_png'

module Cryptolalia
  class Cipher

    ### Steganography PNG cipher (http://en.wikipedia.org/wiki/Steganography)
    #
    # Hide your plaintext in the PNG image of your choice! Afterwards, the image quality will probably be a little worse
    # (in the case of lsb) or the image size larger (in the case of comments).
    #
    class Steganography < Cipher
      required_attr :file, for: :all

      ### Encoding Usage
      #
      # After successful encoding, only true is returned. The encoded image is directly output onto the filesystem at the
      # location of the output_file attribute.
      #
      ## Required
      # file - the image in which to encode the cipher.
      # output_file - the name of the file to save the encoded image to.
      #
      ## Optional
      # encoded_in - how to encode the cipher in the image. Either :comment (and the plaintext is hidden as a comment on the
      #              image) or :lsb (the plaintext is encoded among the least-significant bytes of the image). Note that for
      #              :lsb, if the plaintext is too long, the image will not resemble the original image very well at all.
      #              (Default: :lsb)
      #
      required_attr :output_file, for: :encoding
      required_attr :plaintext, for: :encoding
      optional_attr :encoded_in, default: :lsb, for: :encoding
      attr_accessor :plaintext_position

      def perform_encode!
        raise Cryptolalia::Errors::NotEncodable, "No encoder #{self.encoded_in} found" unless self.respond_to?("encode_#{self.encoded_in}")

        self.send("encode_#{self.encoded_in}")

        true
      end

      def encode_comment
        png.metadata['Comment'] = self.plaintext
        png.save(self.output_file)
      end

      def encode_lsb
        @plaintext_position = 0

        (0..7).each do |bit|
          break if @plaintext_position >= plaintext_bytes.length - 1
          encode_in_bit(bit)
        end

        png.save(self.output_file)
      end

      def encode_in_bit(bit = 0)
        png.width.times do |x|
          png.height.times do |y|
            bytes = ChunkyPNG::Color.to_truecolor_alpha_bytes(png[x, y])
            bits = bytes.collect {|b| b.to_s(2).rjust(8, '0')}
            bits.each do |b|
              break if plaintext_bytes[@plaintext_position].nil?

              b[-bit - 1] = plaintext_bytes[@plaintext_position]

              @plaintext_position += 1
            end

            png[x, y] = ChunkyPNG::Color.rgba(*bits.collect {|b| b.to_i(2)})
          end
        end
      end

      ### Decoding Usage
      #
      # Note that decoding lsb is likely to generate a lot of non-text information. It's up to you to sort the actual
      # message out from all the noise. (Hint: if there is one, it should be towards the beginning.)
      #
      ## Required
      # file - the image in which the cipher is encoded.
      # encoded_in - how to cipher was encoded in the image. Either :comment (and the plaintext is hidden as a comment on the
      #              image) or :lsb (the plaintext is encoded among the least-significant bytes of the image).
      #
      required_attr :encoded_in, for: :decoding
      attr_accessor :message_bits

      def perform_decode!
        raise Cryptolalia::Errors::NotDecodable, "No decoder #{self.encoded_in} found" unless self.respond_to?("decode_#{self.encoded_in}")

        self.send("decode_#{self.encoded_in}")
      end

      def decode_comment
        png.metadata['Comment']
      end

      def decode_lsb
        self.message_bits = ''

        (0..7).each do |bit|
          decode_in_bit(bit)
        end

        self.plaintext = self.message_bits.scan(/.{8}/).collect {|b| b.to_i(2)}.pack('c*')
      end

      def decode_in_bit(bit = 0)
        png.width.times do |x|
          png.height.times do |y|
            bytes = ChunkyPNG::Color.to_truecolor_alpha_bytes(png[x, y])
            bits = bytes.collect {|b| b.to_s(2).rjust(8, '0')}
            bits.each {|b| self.message_bits << b[-bit - 1]}
          end
        end
      end

      private

      def plaintext_bytes
        @plaintext_bytes ||= plaintext.bytes.collect {|b| b.to_s(2).rjust(8, '0')}.join('')
      end

      def png
        @png ||= ChunkyPNG::Image.from_file(self.file)
      end

    end
  end
end
