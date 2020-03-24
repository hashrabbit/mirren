require 'mirren/info/algorithm'

module Mirren
  module Accounts
    class Profile < BaseStruct
      attribute :id, Types::Coercible::Integer
      attribute :name, Types::String
      attribute :algo, Info::Algorithm
      attribute :pools, Types::Array.of(Pool)
      attribute :default, Types::Bool
    end
  end
end
