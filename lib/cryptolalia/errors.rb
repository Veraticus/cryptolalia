module Cryptolalia
  # All the error specific to Cryptolalia.
  module Errors

    # Generic error class.
    class Error < StandardError; end

    # AttributeMissing is for ciphers that try to run without information added that they need.
    class AttributeMissing < Error; end

    # NotEncodable is for text that is for some reason not encodable; give additional information as to why.
    class NotEncodable < Error; end

    # NotDecodable is for text that is similary not decodable. Additional information is helpful.
    class NotDecodable < Error; end
  end
end
