module Cryptolalia
  class Cipher

    ### The Atbash inversion cipher (http://en.wikipedia.org/wiki/Atbash)
    #
    # This cipher reverses each letter of the plaintext's order in the target alphabet.
    class Atbash < Cipher
      optional_attr :alphabet, default: ('a'..'z').to_a, for: [:encoding, :decoding]

      ### Encoding Usage
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
          raise Cryptolalia::Errors::NotEncodable, "Could not find a #{letter} in the alphabet" unless i

          new_i = (-i - 1) % self.alphabet.size

          ciphertext << self.alphabet.to_a[new_i]
        end

        ciphertext.strip
      end

      ### Decoding Usage
      #
      ## Optional
      # alphabet - the default alphabet to use. (Default: ('a'..'z').to_a)
      #
      required_attr :ciphertext, for: :decoding

      def perform_decode!
        original_ciphertext = self.plaintext = self.ciphertext

        result = perform_encode!

        self.ciphertext = original_ciphertext
        result
      end
    end
  end
end
