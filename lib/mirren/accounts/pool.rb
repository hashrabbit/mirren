module Mirren
  module Accounts
    class Pool < BaseStruct
      attribute :id, Types::Coercible::Integer
      attribute :priority, Types::Integer
      attribute :type, Types::String
      attribute :name, Types::String
      attribute :host, Types::String
      attribute :port, Types::Coercible::Integer
      attribute :user, Types::String
      attribute :pass, Types::String
      attribute? :notes, Types::String
      attribute? :pool_option1, Types::NilOrString
    end
  end
end
