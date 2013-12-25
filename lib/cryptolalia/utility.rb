require 'timeout'

module Cryptolalia

  # Some helpful utility functions
  module Utility
    extend self

    # Generate one random utf8 letter
    def random_utf8
      string = ''
      8.times do
        string << rand(2).to_s
      end
      [string.to_i(2)].pack('c*')
    end

    # Create a non-repeating alphabet of X characters
    def random_alphabet(x = 26, excluded_characters = [])
      alphabet = []

      Timeout::timeout(5) {
        until alphabet.count == 26
          char = self.random_utf8
          next if alphabet.include?(char) || excluded_characters.include?(char)
          alphabet << char
        end
      }

      alphabet
    end
  end
end
