module Mirren
  class Client
    include Info::Endpoints
    include Accounts::Endpoints
    include Rigs::Endpoints
    include Rentals::Endpoints

    def request
      @request ||= ->(args) { RestClient::Request.execute(args) }
    end
  end
end
