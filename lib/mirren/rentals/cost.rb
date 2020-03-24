module Mirren
  module Rentals
    class Cost < BaseStruct
      attribute :type, Types::String
      attribute :advertised, Types::FloatString
      attribute? :paid, Types::FloatString
      attribute :currency, Types::String
    end
  end
end
