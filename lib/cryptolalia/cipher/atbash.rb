module Cryptolalia
  class Cipher

    ### The Atbash inversion cipher (http://en.wikipedia.org/wiki/Atbash)
    #
    # This cipher reverses each letter of the plaintext's order in the target alphabet.
    #
    ### Usage
    #
    ## Optional
    # alphabet - the default alphabet to use. (Default: ('a'..'z').to_a)
    #
    class Atbash < Cipher
      optional_attr :alphabet, ('a'..'z').to_a

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
    end
  end
end
