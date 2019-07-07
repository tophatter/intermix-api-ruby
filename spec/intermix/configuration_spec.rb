# rspec spec/configuration_spec.rb
RSpec.describe Intermix::Configuration do
  describe '#initialize' do

    subject { Intermix::Configuration.new(api_token: api_token) }
    
    context 'when api_token is nil' do
      let(:api_token) { nil }
      
      it 'throws an error' do
        expect { subject }.to raise_error(ArgumentError, 'api_token cannot be nil.')
      end
    end
  end
end
