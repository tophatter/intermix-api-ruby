module Intermix
  class Configuration
    CLUSTER = 'RedshiftCluster'
    API_URL = 'https://dashboard.intermix.io/api'

    attr_reader :cluster, :api_url, :api_token

    def initialize(cluster: CLUSTER, api_url: API_URL, api_token:)
      raise ArgumentError, 'api_token cannot be nil.' if api_token.nil?
    end
  end
end
