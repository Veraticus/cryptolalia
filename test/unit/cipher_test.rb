require 'test_helper'

class CipherTest < MiniTest::Test

  class NotCipher < Cryptolalia::Cipher
    required_attr :needed
    optional_attr :fun, true

    def encode!
      self.plaintext
    end
  end

  def setup
    super
    @cipher = NotCipher.new
  end

  def test_allows_optional_parameters
    assert @cipher.respond_to?(:fun)
    assert @cipher.respond_to?(:fun=)
    assert_equal true, @cipher.fun
  end

  def test_forces_required_parameters
    @cipher.needed = true

    assert @cipher.respond_to?(:plaintext)
    assert @cipher.respond_to?(:plaintext=)

    assert_raises Cryptolalia::Errors::AttributeMissing do
      @cipher.validate!
    end

    @cipher.plaintext = "Hello, darling."
    @cipher.validate!
  end

  def test_cleans_plaintext_by_downcasing_and_removing_punctuation
    @cipher.plaintext = "Hello, darling."

    assert_equal 'hello darling', @cipher.cleaned_plaintext
  end

end
