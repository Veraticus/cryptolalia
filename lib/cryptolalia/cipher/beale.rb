module Cryptolalia
  class Cipher

    ### The Beale homophonic substitution cipher (http://en.wikipedia.org/wiki/Substitution_cipher#Homophonic_substitution)
    #
    # Not limited to just the Declaration of Independence anymore! The Beale homophonic substitution cipher works on a
    # text. For each letter of the plaintext, a word from the file is selected with the same first letter: its positional
    # number in the text is added to the ciphertext.
    #
    ### Usage
    #
    ## Required
    # file - the text source for the cipher.
    #
    ## Optional
    # only_first_word - whether the cipher should always choose the first word, or any random word. (Default: false)
    # nth_letter - which letter of the word should be chosen for the ciphertext. (Default: 1)
    #
    class Beale < Cipher
      required_attr :file
      optional_attr :only_first_word, false
      optional_attr :nth_letter, 1

      def perform_encode!
        letters = Hash.new{|h, k| h[k] = []}

        position = 0
        source_text.split(/\s/).each do |word|
          next unless word =~ /[a-zA-Z0-9]+/
          position += 1
          letters[word.downcase.gsub(/[\W]/, '')[self.nth_letter - 1]] << position
        end

        ciphertext = ''
        self.cleaned_plaintext.split('').each do |letter|
          next if letter =~ /[\s\W]/

          possibilities = letters[letter]
          raise Cryptolalia::Errors::NotEncodable, "Could not find a word starting with #{letter}" if possibilities.empty?

          if self.only_first_word
            ciphertext << possibilities.first.to_s
          else
            ciphertext << possibilities.sample.to_s
          end

          ciphertext += " "
        end

        ciphertext.strip
      end

      def source_text
        @text ||=
          File.open(self.file, 'r') do |f|
            words = f.read
            words.downcase.gsub(/[^a-zA-Z0-9\s]/, '').gsub(/\s+/,' ')
          end
      end
    end
  end
end