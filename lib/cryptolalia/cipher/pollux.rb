module Cryptolalia
  class Cipher

    ### Pollux cipher (http://www.cryptool-online.org/index.php?option=com_content&view=article&id=66&Itemid=76&lang=en)
    #
    # Use the power of Morse code to hide your message! Translates each character in the plaintext into the Morse
    # alphabet, and then maps it into a random digit from a new alphabet. If you don't supply your own alphabet,
    # cryptolalia will create its own. After ciphertext generation, use the optional methods :dot, :dash, and :separator
    # to find out what cryptolalia decided on for those characters.
    #
    class Pollux < Cipher

      MORSE_ALPHABET = {
        a: '.-',
        b: '-...',
        c: '-.-.',
        d: '-..',
        e: '.',
        f: '..-.',
        g: '--.',
        h: '....',
        i: '..',
        j: '.---',
        k: '-.-',
        l: '.-..',
        m: '--',
        n: '-.',
        o: '---',
        p: '.--.',
        q: '--.-',
        r: '.-.',
        s: '...',
        t: '-',
        u: '..-',
        v: '...-',
        w: '.--',
        x: '-..-',
        y: '-.--',
        z: '--..'
      }

      ### Encoding Usage
      #
      ## Optional
      # dot - what characters will map to dots. (Default: 10 random UTF-8 characters)
      # dash - what characters will map to dots. (Default: 10 random UTF-8 characters)
      # separator - what characters will map to dots. (Default: 10 random UTF-8 characters)
      #
      required_attr :plaintext, for: :encoding
      optional_attr :dot, for: :encoding
      optional_attr :dash, for: :encoding
      optional_attr :separator, for: :encoding

      def perform_encode!
        setup_alphabet!

        ciphertext = ''

        self.cleaned_plaintext.split('').each do |letter|
          morse = MORSE_ALPHABET[letter.downcase.to_sym]
          raise Cryptolalia::Errors::NotEncodable, "Could not find a Morse translation for letter #{letter}" if morse.nil?

          morse.split('').each do |l|
            if l == '-'
              ciphertext << self.dash.sample
            else
              ciphertext << self.dot.sample
            end
          end

          ciphertext << self.separator.sample
        end

        ciphertext
      end

      ### Decoding Usage
      #
      ## Required
      # dot - what characters will map to dots.
      # dash - what characters will map to dots.
      # separator - what characters will map to dots.
      #
      required_attr :ciphertext, for: :decoding
      required_attr :dot, for: :decoding
      required_attr :dash, for: :decoding
      required_attr :separator, for: :decoding

      def perform_decode!
        plaintext = ''
        current_character = ''

        self.cleaned_ciphertext.split('').each do |char|
          if self.dot.include?(char)
            current_character << '.'
          elsif self.dash.include?(char)
            current_character << '-'
          elsif self.separator.include?(char)
            plaintext << MORSE_ALPHABET.invert[current_character].to_s
            current_character = ''
          else
            raise Cryptolalia::Errors::NotDecodable, "Could not find a translation for letter #{char}"
          end
        end

        plaintext
      end

      def alphabet
        [self.dot, self.dash, self.separator].flatten.uniq
      end

      # Remove all spaces and non-word letters from the target string
      def cleaned_plaintext
        super.gsub(/[\s\W]/, '')
      end

      # Any character could potentially be in an alphabet
      def cleaned_ciphertext
        ciphertext
      end

      private

      def setup_alphabet!
        [:dot, :dash, :separator].each do |kind|
          next unless self.send(kind).nil?

          self.send("#{kind}=", Cryptolalia::Utility.random_alphabet(10, self.alphabet))
        end
      end

    end
  end
end