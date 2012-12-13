# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vend/version'

Gem::Specification.new do |gem|
  gem.name          = "vending-machine"
  gem.version       = Vend::VERSION
  gem.authors       = ["Mal Curtis"]
  gem.email         = ["mal@mal.co.nz"]
  gem.description   = %q{Client for the Vend API}
  gem.summary       = %q{Exposes the Vend API as an object model}
  gem.homepage      = "https://github.com/snikch/vending-machine"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.require_paths = ["lib"]

  ##
  # Runtime dependencies.

  # Faraday: HTTP client.
  gem.add_runtime_dependency "faraday"
  gem.add_runtime_dependency "faraday_middleware"

  # Addressable: URI implementation.
  gem.add_runtime_dependency "addressable"

  # Virtus: declare attributes on plain Ruby objects.
  gem.add_runtime_dependency "virtus", "~> 0.5.3"

  ##
  # Development dependencies.

  # MiniTest: unit test / spec library.
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "ansi"
  gem.add_development_dependency "turn"

  # Rake: build tool.
  gem.add_development_dependency "rake"

  # WebMock: HTTP request stubs and expectations.
  gem.add_development_dependency "webmock"
end
