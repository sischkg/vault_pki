# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vault_pki/version"

Gem::Specification.new do |spec|
  spec.name          = "vault_pki"
  spec.version       = VaultPKI::VERSION
  spec.authors       = ["Toshifumi Sakaguchi"]
  spec.email         = ["t-sakaguchi@fusioncom.co.jp"]

  spec.summary       = %q{generate certificate and private key by Hashicorp Vault PKI Secrets Engine.}
  spec.description   = %q{generate certificate and private key by Hashicorp Vault PKI Secrets Engine.}
  spec.homepage      = "https://github.com/sischkg/vault_pki"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
