module Cryptolalia
  class Cipher

    ### The Caesar cipher (http://en.wikipedia.org/wiki/Caesar_cipher)
    #
    # Good enough for Roman emperors! Turns each letter into another letter a fixed position away from it in the alphabet.
    #
    class Caesar < Cipher
      required_attr :rot, for: :all
      optional_attr :alphabet, default: ('a'..'z').to_a, for: :all

      ### Encoding Usage
      #
      ## Required
      # rot - the distance to rotate through the alphabet.
      #
      ## Optional
      # alphabet - the default alphabet to use. (Default: ('a'..'z').to_a)
      #
      required_attr :plaintext, for: :encoding

      def perform_encode!
        ciphertext = ''

        self.cleaned_plaintext.split('').each do |letter|
          ciphertext << letter && next if letter =~ /[\s\W]/

          i = self.alphabet.index(letter)
          raise Cryptolalia::Errors::NotEncodable, "Could not find #{letter} in the alphabet" unless i

          new_i = (i + self.rot) % self.alphabet.size

          ciphertext << self.alphabet.to_a[new_i]
        end

        ciphertext.strip
      end

      ### Decoding Usage
      #
      ## Required
      # rot - the distance to rotate through the alphabet.
      #
      ## Optional
      # alphabet - the default alphabet to use. (Default: ('a'..'z').to_a)
      #
      required_attr :ciphertext, for: :decoding

      def perform_decode!
        original_ciphertext = self.plaintext = self.ciphertext
        original_rot = self.rot
        self.rot = -self.rot

        result = perform_encode!

        self.ciphertext = original_ciphertext
        self.rot = original_rot
        result
      end
    end
  end
end
