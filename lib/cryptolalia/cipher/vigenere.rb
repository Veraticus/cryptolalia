module Cryptolalia
  class Cipher

    ### The Vigenere cipher (http://en.wikipedia.org/wiki/Vigenere_cipher)
    #
    # This cipher takes a keyword and an alphabet. It performs a Caesar substitution for each letter of the
    # ciphertext based on repeating the key over and over.
    #
    class Vigenere < Cipher
      optional_attr :alphabet, default: ('a'..'z').to_a, for: :all
      required_attr :keyword, for: :all

      ### Encoding Usage
      #
      ## Required
      # keyword - the keyword to use to encode the cipher.
      #
      ## Optional
      # alphabet - the default alphabet to use. (Default: ('a'..'z').to_a)
      #
      required_attr :plaintext, for: :encoding

      def perform_encode!
        ciphertext = ''
        position = 0

        self.cleaned_plaintext.split('').each do |letter|
          ciphertext << letter && next if letter =~ /[\s\W]/

          keyletter = keyword[position % keyword.length]
          i = self.alphabet.index(letter)
          offset = self.alphabet.index(keyletter)

          raise Cryptolalia::Errors::NotEncodable, "Could not find ciphertext letter #{letter} in the alphabet" unless i
          raise Cryptolalia::Errors::NotEncodable, "Could not find keyword letter #{letter} in the alphabet" unless offset

          new_i = (i + offset) % self.alphabet.size

          ciphertext << self.alphabet.to_a[new_i]
          position += 1
        end

        ciphertext.strip
      end

      ### Decoding Usage
      #
      ## Required
      # keyword - the keyword to use to encode the cipher.
      #
      #
      ## Optional
      # alphabet - the default alphabet to use. (Default: ('a'..'z').to_a)
      #
      required_attr :ciphertext, for: :decoding

      def perform_decode!
        plaintext = ''
        position = 0

        self.cleaned_ciphertext.split('').each do |letter|
          plaintext << letter && next if letter =~ /[\s\W]/

          keyletter = keyword[position % keyword.length]
          i = self.alphabet.index(letter)
          offset = self.alphabet.index(keyletter)

          raise Cryptolalia::Errors::NotEncodable, "Could not find plaintext letter #{letter} in the alphabet" unless i
          raise Cryptolalia::Errors::NotEncodable, "Could not find keyword letter #{letter} in the alphabet" unless offset

          new_i = (i + -offset) % self.alphabet.size

          plaintext << self.alphabet.to_a[new_i]
          position += 1
        end

        plaintext.strip
      end

    end
  end
end
