module Cryptolalia
  class Cipher

    ### Pollux cipher (http://www.cryptool-online.org/index.php?option=com_content&view=article&id=66&Itemid=76&lang=en)
    #
    # Use the power of Morse code to hide your message! Translates each character in the plaintext into the Morse
    # alphabet, and then maps it into a random digit from a new alphabet. If you don't supply your own alphabet,
    # cryptolalia will create its own. After ciphertext generation, use the optional methods :dot, :dash, and :seperator
    # to find out what cryptolalia decided on for those characters.
    #
    ### Usage
    #
    ## Optional
    # dot - what characters will map to dots. (Default: 10 random UTF-8 characters)
    # dash - what characters will map to dots. (Default: 10 random UTF-8 characters)
    # seperator - what characters will map to dots. (Default: 10 random UTF-8 characters)
    #
    class Pollux < Cipher
      optional_attr :dot
      optional_attr :dash
      optional_attr :seperator

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

      def perform_encode!
        setup_alphabet!

        ciphertext = ''

        self.plaintext.split('').each do |letter|
          next if letter =~ /[\s\W]/

          morse = MORSE_ALPHABET[letter.downcase.to_sym]
          raise Cryptolalia::Errors::NotEncodable, "Could not find a Morse translation for letter #{letter}" if morse.nil?

          morse.split('').each do |l|
            if l == '-'
              ciphertext << self.dash.sample
            else
              ciphertext << self.dot.sample
            end
          end

          ciphertext << self.seperator.sample
        end

        ciphertext
      end

      def alphabet
        [self.dot, self.dash, self.seperator].flatten.uniq
      end

      private

      def setup_alphabet!
        [:dot, :dash, :seperator].each do |kind|
          next unless self.send(kind).nil?

          self.send("#{kind}=", Cryptolalia::Utility.random_alphabet(10, self.alphabet))
        end
      end

    end
  end
end