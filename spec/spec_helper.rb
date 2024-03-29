require 'intermix'
require 'awesome_print'
require 'approvals/rspec'
require 'coveralls'

Coveralls.wear!

RSpec.configure do |rspec|
  # This config option will be enabled by default on RSpec 4,
  # but for reasons of backwards compatibility, you have to
  # set it on RSpec 3.
  #
  # It causes the host group and examples to inherit metadata
  # from the shared context.
  rspec.shared_context_metadata_behavior = :apply_to_host_groups
end

Approvals.configure do |config|
  config.approvals_path = 'spec/fixtures/approvals/'
end

gemspec = Gem::Specification.find_by_name('intermix-client')
Dir["#{gemspec.gem_dir}/spec/support/**/*.rb"].each { |f| require f }
