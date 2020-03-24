module Mirren
  module Accounts
    class Account < BaseStruct
      attribute :username, Types::String
      attribute :email, Types::String
      attribute :withdraw do
        attribute :BTC do
          attribute :address, Types::NilOrString
          attribute :label, Types::NilOrString
          attribute :auto_pay_threshold, Types::FloatString
          attribute :txfee, Types::FloatString
        end
      end
      attribute :deposit do
        attribute :BTC do
          attribute :address, Types::NilOrString
        end
      end
      attribute :notifications do
        attribute :rental_comm, Types::YesBool
        attribute :new_rental, Types::YesBool
        attribute :offline, Types::YesBool
        attribute :news, Types::YesBool
        attribute :deposit, Types::YesBool
      end
      attribute :settings do
        attribute :live_data, Types::YesBool
        attribute :public_profile, Types::YesBool
        attribute :two_factor, Types::YesBool
      end
    end
  end
end
