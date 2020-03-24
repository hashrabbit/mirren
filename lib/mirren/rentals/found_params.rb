module Mirren
  module Rentals
    class FoundParams < BaseStruct
      attribute? :type, Types::String.enum('renter', 'owner')
      attribute? :algo, Types::String
      attribute :history, Types::Bool.default(false)
      attribute? :rig, Types::Integer
      attribute? :currency, Types::String.enum('BTC', 'LTC', 'ETH', 'DASH')
      attribute :start, Types::Integer.default(0)
      attribute :limit, Types::Integer.default(25)
    end
  end
end
