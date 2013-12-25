require 'tempfile'
require 'oily_png'

module Cryptolalia
  class Cipher

    ### Steganography PNG cipher (http://en.wikipedia.org/wiki/Steganography)
    #
    # Hide your plaintext in the PNG image of your choice! Note that for this cipher, the output ciphertext is always true:
    # you'll need to set output_file to redirect the created image to a file.
    #
    ### Usage
    #
    ## Required
    # file - the image in which to encode the cipher.
    # output_file - the name of the file to save the encoded image to.
    #
    ## Optional
    # encode_in - how to encode the cipher in the image. Either :comment (and the plaintext is hidden as a comment on the
    #             image) or :lsb (the plaintext is encoded among the least-significant bytes of the image). Note that for
    #             :lsb, if the plaintext is too long, the image will not resemble the original image very well at all.
    #             (Default: :lsb)
    #
    class Steganography < Cipher
      required_attr :file
      required_attr :output_file
      optional_attr :encode_in, :lsb

      attr_accessor :plaintext_position

      def perform_encode!
        raise Cryptolalia::Errors::NotEncodable, "No encoder #{self.encode_in} found" unless self.respond_to?(self.encode_in)

        self.send(self.encode_in)

        true
      end

      def comment
        png.metadata['Comment'] = self.plaintext
        png.save(self.output_file)
      end

      def lsb
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
