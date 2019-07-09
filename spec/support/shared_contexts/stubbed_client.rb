RSpec.shared_context 'stubbed_client' do
  let(:api_token) { 'token' }
  let(:cluster_id) { 1 }

  let(:stubbed_configuration) { Intermix::Configuration.new(api_token: api_token, cluster_id: cluster_id) }
  let(:stubbed_client) { Intermix::Client.new(stubbed_configuration) }

  # tables
  let(:stubbed_table) do
    {
      db_id: '1',
      db_name: 'db1',
      schema_id: 1,
      schema_name: 'public',
      table_id: 1,
      table_name: 'events',
      stats_pct_off: 12,
      size_pct_unsorted: 13,
      row_count: 123_456,
      sort_key: 'id'
    }
  end

  let(:successful_response) { OpenStruct.new('code': 200, success?: true, 'data': [stubbed_table].to_json, parsed_response: { 'data' => [stubbed_table] }) }
  let(:failed_response)     { OpenStruct.new('code': 403, 'data': nil) }
end

RSpec.configure do |rspec|
  rspec.include_context 'stubbed_client', stubbed_client: true
end
