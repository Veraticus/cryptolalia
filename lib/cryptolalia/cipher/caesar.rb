module Cryptolalia
  class Cipher

    ### The Caesar cipher (http://en.wikipedia.org/wiki/Caesar_cipher)
    #
    # Good enough for Roman emperors! Turns each letter into another letter a fixed position away from it in the alphabet.
    #
    ### Usage
    #
    ## Required
    # rot - the distance to rotate through the alphabet.
    #
    ## Optional
    # alphabet - the default alphabet to use. (Default: ('a'..'z').to_a)
    #
    class Caesar < Cipher
      required_attr :rot
      optional_attr :alphabet, ('a'..'z').to_a

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

    end
  end
end
