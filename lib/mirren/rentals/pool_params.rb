module Mirren
  module Rentals
    class PoolParams < BaseStruct
      attribute :priority, Types::Integer
      attribute :host, Types::String
      attribute :port, Types::Integer
      attribute :user, Types::String
      attribute :pass, Types::String
    end
  end
end
