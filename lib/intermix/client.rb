module Intermix
  class Client
    # paths
    TABLES_PATH = '/tables'

    attr_reader :configuration

    def initialize(configuration)
      raise ArgumentError, 'configuration cannot be nil.' unless configuration.present?

      @configuration = configuration
    end

    def tables(fields)
      fields &&= Table::FIELDS
      query = "fields=#{fields.join(',')}" if fields.any?

      response = post(TABLES_PATH, query: query)

      if response.success?
        parsed_response = response.parsed_response
        parsed_response['data'].map { |entry| Intermix::Table.new(entry) }
      else
        []
      end
    end

    private

    def post(path, query: nil)
      uri = "#{@configuration.base_uri}#{path}?" + query

      HTTParty.post(uri, headers: headers)
    end

    def headers
      { 'Authorization' => "Token #{@configuration.api_token}" }
    end
  end
end
