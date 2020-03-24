module Mirren
  module Rigs
    class Hashrate < BaseStruct
      attribute :hash, Types::FloatString
      attribute :type, Types::String
      attribute :nice, Types::String
    end
  end
end
