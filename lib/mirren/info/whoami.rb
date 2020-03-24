module Mirren
  module Info
    class Whoami < Mirren::BaseStruct
      attribute :userid, Types::IntString
      attribute :username, Types::String
      attribute :api_key, Types::String
      attribute :api_sign, Types::String
      attribute :api_nonce, Types::IntString
      attribute :authed, Types::Bool
      attribute :auth_mesage, Types::String
      attribute :permissions do
        attribute :withdraw, Types::String
        attribute :rent, Types::String
        attribute :rigs, Types::String
      end
    end
  end
end
