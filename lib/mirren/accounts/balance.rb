require 'mirren/accounts/balance_amount'

module Mirren
  module Accounts
    class Balance < BaseStruct
      attribute :BTC, BalanceAmount
      attribute :BCH, BalanceAmount
      attribute :LTC, BalanceAmount
      attribute :ETH, BalanceAmount
      attribute :DASH, BalanceAmount
    end
  end
end
