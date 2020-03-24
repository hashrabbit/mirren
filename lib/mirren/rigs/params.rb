module Mirren
  module Rigs
    class Params < BaseStruct
      attribute :type, Types::String
      attribute :offline, Types::Bool.default(false)
      attribute :rented, Types::Bool.default(false)
      attribute? :minhours do
        attribute? :min, Types::Integer
        attribute? :max, Types::Integer
      end
      attribute? :maxhours do
        attribute? :min, Types::Integer
        attribute? :max, Types::Integer
      end
      attribute? :rpi do
        attribute? :min, Types::Integer
        attribute? :max, Types::Integer
      end
      attribute? :hash do
        attribute? :min, Types::Integer
        attribute? :max, Types::Integer
        attribute? :type, Types::HashTypes
      end
      attribute? :count, Types::Integer
      attribute? :offset, Types::Integer
      attribute? :orderby, Types::String
      attribute? :orderdir, Types::String
    end
  end
end
