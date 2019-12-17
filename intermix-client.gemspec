# To publish the next version:
# gem build intermix-client.gemspec
# gem push intermix-client-{VERSION}.gem
Gem::Specification.new do |s|
  s.name        = 'intermix-client'
  s.version     = '0.0.4'
  s.platform    = Gem::Platform::RUBY
  s.licenses    = ['MIT']
  s.authors     = ['Joe Manley']
  s.email       = ['joemanley201@gmail.com']
  s.homepage    = 'https://github.com/tophatter/intermix-api-ruby'
  s.summary     = 'Intermix API Client in Ruby'
  s.description = 'Intermix API Client in Ruby'

  s.extra_rdoc_files = ['README.md']

  s.add_dependency 'activesupport', '>= 4.2'
  s.add_dependency 'httparty', '>= 0.14.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']
end
