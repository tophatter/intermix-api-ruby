module Intermix
  class Configuration
    CLUSTER_TYPE = 'RedshiftCluster'
    API_URL      = 'https://dashboard.intermix.io/api'

    attr_reader :api_token, :cluster_id, :cluster_type, :api_url

    def initialize(api_token:, cluster_id:)
      raise ArgumentError, 'api_token cannot be nil.' unless api_token.present?
      raise ArgumentError, 'cluster_id cannot be nil.' unless cluster_id.present?

      @api_token  = api_token
      @cluster_id = cluster_id

      @cluster_type = CLUSTER_TYPE
      @api_url      = API_URL
    end

    def base_uri
      @base_uri = "#{@api_url}/#{@cluster_type}/#{@cluster_id}" unless defined?(@base_uri)
    end
  end
end
