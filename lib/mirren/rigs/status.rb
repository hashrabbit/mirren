module Mirren
  module Rigs
    class Status < BaseStruct
      attribute :status, Types::String
      attribute :hours, Types::IntString
      attribute :rented, Types::Bool
      attribute :online, Types::Bool
    end
  end
end
