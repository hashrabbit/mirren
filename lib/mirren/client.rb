module Mirren
  class Client
    include Info::Endpoints
    include Accounts::Endpoints
    include Rigs::Endpoints
    include Rentals::Endpoints
  end
end
