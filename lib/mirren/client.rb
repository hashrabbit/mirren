module Mirren
  class Client
    extend Dry::Initializer

    option :host, default: proc { ENV['MIRREN_HOST'] }
    option :api_key, default: proc { ENV['MIRREN_API_KEY'] }
    option :api_secret, default: proc { ENV['MIRREN_API_SECRET'] }
    option :auth, default: proc { Api::Auth.new(api_key, api_secret) }

    include Info::Endpoints
    include Accounts::Endpoints
    include Rigs::Endpoints
    include Rentals::Endpoints

    def request
      @request ||= ->(args) { RestClient::Request.execute(args) }
    end
  end
end
