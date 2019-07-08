# rspec spec/configuration_spec.rb
RSpec.describe Intermix::Configuration do
  describe '#initialize' do
    let(:api_token) { 'token' }
    let(:cluster_id) { 1 }

    subject { Intermix::Configuration.new(api_token: api_token, cluster_id: cluster_id) }
    
    context 'when api_token is nil' do
      let(:api_token) { nil }
      
      it 'throws an error' do
        expect { subject }.to raise_error(ArgumentError, 'api_token cannot be nil.')
      end
    end

    context 'when cluster_id is nil' do
      let(:cluster_id) { nil }
      
      it 'throws an error' do
        expect { subject }.to raise_error(ArgumentError, 'cluster_id cannot be nil.')
      end
    end

    it 'assigns attributes correctly' do
      expect(subject.api_token).to eq(api_token)
      expect(subject.cluster_id).to eq(cluster_id)

      expect(subject.cluster_type).to eq(Intermix::Configuration::CLUSTER_TYPE)
      expect(subject.api_url).to eq(Intermix::Configuration::API_URL)
    end
  end

  describe '#base_uri' do
    let(:api_token) { 'token' }
    let(:cluster_id) { 1 }

    subject { Intermix::Configuration.new(api_token: api_token, cluster_id: cluster_id).base_uri }
    
    it 'returns the correct uri based on api_url, cluster_type and cluster_type' do
      expect(subject).to eq('https://dashboard.intermix.io/api/RedshiftCluster/1')
    end
  end
end
