module Mirren
  class Client
    attr_reader :host, :auth

    def initialize(opts = {})
      @host = opts.fetch(:host, ENV['MIRREN_HOST'])
      api_key = opts.fetch(:api_key, ENV['MIRREN_API_KEY'])
      api_secret = opts.fetch(:api_secret, ENV['MIRREN_API_SECRET'])
      @auth = Api::Auth.new(api_key, api_secret)
    end

    include Info::Endpoints
    include Accounts::Endpoints
    include Rigs::Endpoints
    include Rentals::Endpoints

    def request
      @request ||= ->(args) { RestClient::Request.execute(args) }
    end
  end
end
