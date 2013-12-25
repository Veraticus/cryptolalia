# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cryptolalia/version"

Gem::Specification.new do |s|
  s.name        = "cryptolalia"
  s.version     = Cryptolalia::VERSION
  s.author      = "Veraticus"
  s.email       = "josh@joshsymonds.com"
  s.homepage    = "https://github.com/Veraticus/cryptolalia"
  s.summary     = "Turn plaintexts into ciphertexts with many entertaining ciphers"
  s.description = "cryptolalia is designed to produce fun ciphertext puzzles from plaintexts"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = %w(LICENSE README.markdown)
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">=1.9.1")

  s.add_dependency('rake', '>=10.1.1')
  s.add_dependency('oily_png', '>=1.1.0')
end
