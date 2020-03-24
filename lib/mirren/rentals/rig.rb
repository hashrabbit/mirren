require 'mirren/rigs/hashrate'
require 'mirren/rigs/status'
require 'mirren/rigs/price'

module Mirren
  module Rentals
    class Rig < BaseStruct
      attribute :id, Types::IntString
      attribute :name, Types::String
      attribute :owner, Types::String
      attribute :type, Types::String
      attribute :status, Rigs::Status
      attribute :online, Types::Bool
      attribute :xnonce, Types::YesBool
      attribute :ndevices, Types::IntString
      attribute :region, Types::String
      attribute :rpi, Types::FloatString
      attribute :suggested_diff, Types::FloatString
      attribute :optimal_diff do
        attribute :min, Types::FloatString
        attribute :max, Types::FloatString
      end
      attribute :poolstatus, Types::String
      attribute :extensions, Types::Bool
      attribute :price do
        attribute :type, Types::String
        attribute :BTC, Rigs::Price
      end
      attribute :minhours, Types::IntString
      attribute :maxhours, Types::IntString
      attribute :hashrate do
        attribute :advertised, Rigs::Hashrate
      end
      attribute :available_status, Types::String
      attribute :shorturl, Types::String
    end
  end
end
