module Cryptolalia
  class Cipher

    ### The Beale homophonic substitution cipher (http://en.wikipedia.org/wiki/Substitution_cipher#Homophonic_substitution)
    #
    # Not limited to just the Declaration of Independence anymore! The Beale homophonic substitution cipher works on a
    # text. For each letter of the plaintext, a word from the file is selected with the same first letter: its positional
    # number in the text is added to the ciphertext.
    #
    class Beale < Cipher
      required_attr :file, for: :all
      optional_attr :only_first_word, default: false, for: :all
      optional_attr :nth_letter, default: 1, for: :all

      ### Encoding Usage
      #
      ## Required
      # file - the text source for the cipher.
      #
      ## Optional
      # only_first_word - whether the cipher should always choose the first word, or any random word. (Default: false)
      # nth_letter - which letter of the word should be chosen for the ciphertext. (Default: 1)
      #
      required_attr :plaintext, for: :encoding

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

      ### Decoding Usage
      #
      ## Required
      # file - the text source for the cipher.
      #
      ## Optional
      # nth_letter - which letter of the word should be chosen for the plaintext. (Default: 1)
      #
      required_attr :ciphertext, for: :decoding

      def perform_decode!
        plaintext = ''
        words = self.source_text.split(' ')

        self.cleaned_ciphertext.split(' ').each do |position|
          plaintext << words[position.to_i - 1][self.nth_letter - 1]
        end

        plaintext
      end

      def source_text
        @text ||=
          File.open(self.file, 'r') do |f|
            words = f.read
            words.downcase.gsub(/[^a-zA-Z0-9\s]/, '').gsub(/\s+/,' ')
          end
      end

      # Remove all spaces and non-word letters from the target string
      def cleaned_plaintext
        super.gsub(/[\s\W]/, '')
      end
    end
  end
end