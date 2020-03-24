module Mirren
  module Rentals
    class Pool < BaseStruct
      attribute :priority, Types::IntString
      attribute :type, Types::String
      attribute :host, Types::String
      attribute :port, Types::IntString
      attribute :user, Types::String
      attribute :pass, Types::String
      attribute :status, Types::String
    end
  end
end
