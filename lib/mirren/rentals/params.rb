module Mirren
  module Rentals
    class Params < BaseStruct
      attribute :rig, Types::Integer
      attribute :length, Types::FloatString
      attribute :profile, Types::Integer
      attribute :currency, Types::String.enum('BTC', 'LTC', 'ETH', 'DASH')
      attribute? :rate do
        attribute? :type, Types::String
        attribute? :price, Types::FloatString
      end
    end
  end
end
