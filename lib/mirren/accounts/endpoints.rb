require 'mirren/api'

module Mirren
  module Accounts
    module Endpoints
      include Api

      def fetch_account
        acct = get('/account')
        acct['settings'].tap { |h| h['two_factor'] = h.delete('2factor_auth') }
        Account.new(acct)
      end

      def fetch_account_balance
        fields = get('/account/balance')
        Balance.new(fields)
      end

      def fetch_pools
        get('/account/pool').map { |e| Pool.new(e) }
      end

      def fetch_pool(id:)
        fields = get("/account/pool/#{id}")
        Pool.new(fields)
      end

      def create_pool(params: nil)
        valid_params!(params, PoolParams)

        put('/account/pool', params: params.to_h)
      end

      def delete_pool(id:)
        delete("/account/pool/#{id}")
      end

      def fetch_profiles(algo: nil)
        get('/account/profile', params: { algo: algo }).map do |fields|
          Profile.new(fields)
        end
      end

      def fetch_profile(id:)
        fields = get("/account/profile/#{id}")
        Profile.new(fields)
      end
    end
  end
end
