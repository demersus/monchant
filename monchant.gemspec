# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'monchant/version'

Gem::Specification.new do |spec|
  spec.name          = "monchant"
  spec.version       = Monchant::VERSION
  spec.authors       = ["Nik Petersen"]
  spec.email         = ["nik@petersendata.net"]
  spec.description   = %q{A framework for building purchase/order/line-items models}
  spec.summary       = %q{A framework for building purchase/order/line-items models}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

	spec.add_dependency "mongoid", '~> 3'
	spec.add_dependency "activesupport"
	spec.add_dependency "stripe"
	spec.add_dependency "paypal_adaptive"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
