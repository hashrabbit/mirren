module Mirren
  module Rigs
    class Price < BaseStruct
      attribute :currency, Types::String
      attribute :price, Types::FloatString
      attribute :hour, Types::FloatString
      attribute :minhrs, Types::FloatString
      attribute :maxhrs, Types::FloatString
      attribute :enabled, Types::Bool
    end
  end
end
