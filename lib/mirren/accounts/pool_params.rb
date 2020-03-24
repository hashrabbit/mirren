module Mirren
  module Accounts
    class PoolParams < BaseStruct
      attribute :type, Types::String
      attribute :name, Types::String
      attribute :host, Types::String
      attribute :port, Types::Integer
      attribute :user, Types::String
      attribute? :pass, Types::String
      attribute? :notes, Types::String
    end
  end
end
