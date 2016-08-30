# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zoho_recruiter/version'

Gem::Specification.new do |spec|
  spec.name          = "zoho_recruiter"
  spec.version       = ZohoRecruiter::VERSION
  spec.authors       = ["Andri Kurnia"]
  spec.email         = ["andrikurnia@live.com"]

  spec.summary       = %q{Ruby bindings for Zoho Recruiter API}
  spec.description   = %q{Ruby bindings for Zoho Recruiter API}
  spec.homepage      = "https://github.com/andrkrn/zoho_recruiter"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('httparty', '~> 0.14')

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
