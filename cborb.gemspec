
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cborb/version"

Gem::Specification.new do |spec|
  spec.name          = "cborb"
  spec.version       = Cborb::VERSION
  spec.authors       = ["murakmii"]
  spec.email         = ["bonono.jp@gmail.com"]

  spec.summary       = "Cborb is a pure ruby decoder for CBOR(RFC 7049)"
  spec.description   = "Cborb is a pure ruby decoder for CBOR(RFC 7049)"
  spec.homepage      = "https://github.com/murakmii/cborb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
