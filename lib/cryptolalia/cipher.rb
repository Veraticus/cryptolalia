module Cryptolalia

  # The base class from which all ciphers should inherit.
  #
  ### Usage
  #
  ## Required
  # plaintext - the source text that the cipher will transform into the ciphertext.
  #
  class Cipher
    @@attributes = {
      required: {
        encoding: Hash.new {|h, k| h[k] = []},
        decoding: Hash.new {|h, k| h[k] = []}
      },
      optional: {
        encoding: Hash.new {|h, k| h[k] = []},
        decoding: Hash.new {|h, k| h[k] = []}
      }
    }

    attr_accessor :plaintext, :ciphertext

    # Validate that required attributes are present.
    def validate!(type)
      @@attributes[:required][type][self.class.shortname].each do |attr_name|
        raise Cryptolalia::Errors::AttributeMissing, "Missing required attribute #{attr_name}" if self.send(attr_name).nil?
      end
    end

    # Before encoding or decoding, ensure that validate! is called.
    def encode!
      validate!(:encoding)
      @ciphertext = perform_encode!
    end

    def decode!
      validate!(:decoding)
      @plaintext = perform_decode!
    end

    # Clean the plaintext and ciphertext, downcasing it and removing punctuation.
    def cleaned_plaintext
      plaintext.downcase.gsub(/[^a-zA-Z0-9\s]/, '')
    end

    def cleaned_ciphertext
      ciphertext.downcase.gsub(/[^a-zA-Z0-9\s]/, '')
    end

    class << self
      def shortname
        self.to_s.split('::').last.downcase
      end

      [:required, :optional].each do |attr_type|
        define_method("#{attr_type}_attrs=") do |type, attrs|
          @@attributes[attr_type][type][self.shortname] = attrs
        end

        define_method("#{attr_type}_attrs") do |type|
          @@attributes[attr_type][type][self.shortname]
        end

        define_method("#{attr_type}_attr") do |attr_name, opts = {}|
          opts[:for] = Array(opts[:for])
          opts[:for] = [:encoding, :decoding] if opts[:for] == [:all]

          attr_accessor(attr_name)

          opts[:for].each do |type|
            self.send("#{attr_type}_attrs=", type, [self.send("#{attr_type}_attrs", type), attr_name].flatten.uniq)
          end

          define_method(attr_name) do
            self.instance_variable_get("@#{attr_name}".to_sym) || opts[:default]
          end

        end
      end
    end
  end

end
