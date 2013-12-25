require 'cryptolalia/version'

require 'cryptolalia/cipher'
require 'cryptolalia/errors'
require 'cryptolalia/utility'

Dir["lib/cryptolalia/cipher/*.rb"].each {|cipher| require "cryptolalia/cipher/#{File.basename(cipher)}"}

module Cryptolalia; end
