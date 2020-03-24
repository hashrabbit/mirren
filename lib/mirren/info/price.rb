module Mirren
  module Info
    class Price < BaseStruct
      attribute :amount, Types::FloatString
      attribute :currency, Types::String
      attribute :unit, Types::String
    end
  end
end
