module Mirren
  module Accounts
    class BalanceAmount < BaseStruct
      attribute :confirmed, Types::FloatString
      attribute :unconfirmed, Types::FloatString
    end
  end
end
