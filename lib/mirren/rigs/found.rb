require 'mirren/rigs/rig.rb'
require 'mirren/rigs/stats.rb'

module Mirren
  module Rigs
    class Found < BaseStruct
      attribute :offset, Types::IntString
      attribute :count, Types::IntString
      attribute :total, Types::IntString
      attribute :stats do
        attribute :available, Stats
        attribute :rented, Stats
        attribute :prices do
          attribute :lowest, Types::FloatString
          attribute :last_10, Types::FloatString
          attribute :last, Types::FloatString
        end
      end
      attribute :records, Types::Array.of(Rig)
    end
  end
end
