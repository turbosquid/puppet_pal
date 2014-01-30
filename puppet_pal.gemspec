# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet_pal/version'

Gem::Specification.new do |spec|
  spec.name          = "puppet_pal"
  spec.version       = PuppetPal::VERSION
  spec.authors       = ["Michael Owings"]
  spec.email         = ["mowings@turbosquid.com"]
  spec.description   = %q{A simpler, faster version of librarian-puppet -- pulls specified modules from soure control}
  spec.summary       = %q{Puppet Pal!}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f|  puts f; File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  # spec.add_dependency('activesupport', '~> 3.2')
end
