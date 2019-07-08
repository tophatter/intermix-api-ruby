# To publish the next version:
# gem build intermix-client.gemspec
# gem push intermix-client-{VERSION}.gem
Gem::Specification.new do |spec|
  spec.name          = 'intermix-client'
  spec.version       = '0.0.1'
  spec.authors       = ['Joe Manley']
  spec.email         = ['joemanley201@gmail.com']

  spec.summary       = 'Intermix API Client in Ruby'
  spec.description   = 'Intermix API Client in Ruby'
  spec.homepage      = 'https://github.com/tophatter/intermix-api-ruby'
  spec.license       = 'MIT'

  spec.required_ruby_version = '~> 2.3'

  spec.add_dependency 'activesupport', '~> 4.2'
  spec.add_dependency 'httparty',      '~> 0.14.0'

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
