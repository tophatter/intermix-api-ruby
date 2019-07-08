# rspec spec/client_spec.rb
RSpec.describe Intermix::Client do
  describe '#initialize' do
    subject { Intermix::Client.new(configuration) }

    context 'when configuration is nil' do
      let(:configuration) { nil }

      it 'throws an error' do
        expect { subject }.to raise_error(ArgumentError, 'configuration cannot be nil.')
      end
    end

    context 'when configuration is present', :stubbed_client do
      let(:configuration) { stubbed_configuration }

      it 'returns a client object' do
        expect(subject).to be_present
      end
    end
  end

  describe '#tables', :stubbed_client do
    let(:client) { stubbed_client }

    subject { client.tables(Intermix::Table::FIELDS) }

    before { allow(HTTParty).to receive(:post).with(any_args).and_return(response) }

    context 'when the response is successful' do
      let(:response) { successful_response }

      it 'returns instances of Intermix::Table' do
        expect(subject.first.is_a?(Intermix::Table)).to be_truthy
      end
    end

    context 'when the response is not successful' do
      let(:response) { failed_response }

      it 'returns an empty array' do
        expect(subject).to be_empty
      end
    end
  end
end
