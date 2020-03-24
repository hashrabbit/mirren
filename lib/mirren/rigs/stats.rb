module Mirren
  module Rigs
    class Stats < BaseStruct
      attribute :rigs, Types::Coercible::Integer
      attribute :hash do
        attribute :hash, Types::FloatString
        attribute? :unit, Types::String
        attribute? :type, Types::String
        attribute :nice, Types::String
      end
    end
  end
end
