require 'mirren/info/price'
require 'mirren/rigs/stats'

module Mirren
  module Info
    class Algorithm < BaseStruct
      attribute :name, Types::String
      attribute :display, Types::String
      attribute :suggested_price, Price
      attribute :stats do
        attribute :available, Rigs::Stats
        attribute :rented, Rigs::Stats
        attribute :prices do
          attribute :lowest, Price
          attribute :last, Price
          attribute :last_10, Price
        end
      end
      attribute? :new, Types::Bool
      attribute? :hot, Types::Bool
      attribute? :hashtype, Types::String
      attribute? :pool_option1, Types::NilOrString
    end
  end
end
