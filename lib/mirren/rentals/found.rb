require 'mirren/rentals/rental.rb'

module Mirren
  module Rentals
    class Found < BaseStruct
      attribute :total, Types::IntString
      attribute :returned, Types::IntString
      attribute :start, Types::IntString
      attribute :limit, Types::IntString
      attribute :rentals, Types::Array.of(Rental)
    end
  end
end
