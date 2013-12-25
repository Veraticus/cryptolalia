module Cryptolalia

  # The base class from which all ciphers should inherit.
  #
  ### Usage
  #
  ## Required
  # plaintext - the source text that the cipher will transform into the ciphertext.
  #
  class Cipher
    @@required_attrs = Hash.new {|h, k| h[k] = [:plaintext]}
    @@optional_attrs = Hash.new {|h, k| h[k] = []}

    attr_accessor :plaintext, :ciphertext

    # Validate that required attributes are present.
    def validate!
      @@required_attrs[self.class.shortname].each do |attr_name|
        raise Cryptolalia::Errors::AttributeMissing, "Missing required attribute #{attr_name}" if self.send(attr_name).nil?
      end
    end

    # Before encoding, ensure that validate! is called.
    def encode!
      validate!
      @ciphertext = perform_encode!
    end

    # Clean the plaintext for ciphering, downcasing it and removing punctuation.
    def cleaned_plaintext
      plaintext.downcase.gsub(/[^a-zA-Z0-9\s]/, '')
    end

    class << self
      def shortname
        self.to_s.split('::').last.downcase
      end

      [:required, :optional].each do |attr_type|
        define_method("#{attr_type}_attrs=") do |attrs|
          hash = self.class_variable_get("@@#{attr_type}_attrs")
          hash[shortname] = attrs
          self.class_variable_set("@@#{attr_type}_attrs", hash)
        end

        define_method("#{attr_type}_attrs") do
          self.class_variable_get("@@#{attr_type}_attrs")[self.shortname]
        end

        define_method("#{attr_type}_attr") do |attr_name, default = nil|
          attr_accessor(attr_name)

          self.send("#{attr_type}_attrs=", [self.send("#{attr_type}_attrs"), attr_name].flatten.uniq)

          define_method(attr_name) do
            self.instance_variable_get("@#{attr_name}".to_sym) || default
          end

        end
      end
    end
  end

end
