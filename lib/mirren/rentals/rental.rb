require 'mirren/rentals/cost'
require 'mirren/rentals/rig'
require 'mirren/rigs/hashrate'

module Mirren
  module Rentals
    class Rental < BaseStruct
      attribute :id, Types::Coercible::Integer
      attribute :owner, Types::String
      attribute :renter, Types::String
      attribute :hashrate do
        attribute :advertised, Rigs::Hashrate
        attribute :average, Rigs::Hashrate
      end
      attribute :price, Cost
      attribute :price_converted, Cost
      attribute :length, Types::IntString
      attribute :extended, Types::IntString
      attribute :start, Types::Params::Time
      attribute :end, Types::Params::Time
      attribute :rig, Rig
    end
  end
end
