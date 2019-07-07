require 'intermix'
require 'awesome_print'

gemspec = Gem::Specification.find_by_name('intermix-client')
Dir["#{gemspec.gem_dir}/spec/support/**/*.rb"].each { |f| require f }
