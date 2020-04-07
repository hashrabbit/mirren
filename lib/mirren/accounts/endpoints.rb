require 'mirren/api'

module Mirren
  module Accounts
    module Endpoints
      include Api

      def fetch_account
        get('/account').bind { |acct|
          acct['settings'].tap { |h| h['two_factor'] = h.delete('2factor_auth') }
          Account.try(acct).to_monad
        }
      end

      def fetch_account!
        fetch_account.value!
      end

      def fetch_account_balance
        fields = get('/account/balance').bind { Balance.try(_1).to_monad }
      end

      def fetch_account_balance!
        fetch_account_balance.value!
      end

      def fetch_pools
        result_list = get('/account/pool')
        Monads.result_list_bind(result_list) { Pool.try(_1).to_monad }
      end

      def fetch_pools!
        fetch_pools.value!
      end

      def fetch_pool(id:)
        get("/account/pool/#{id}").bind { Pool.try(_1).to_monad }
      end

      def fetch_pool!(*args)
        fetch_pool(*args).value!
      end

      def create_pool(params: nil)
        validate_params(params, PoolParams).bind do |params|
          put('/account/pool', params: params.to_h)
        end
      end

      def create_pool!(*args)
        create_pool(*args).value!
      end

      def delete_pool(id:)
        delete("/account/pool/#{id}")
      end

      def delete_pool!(*args)
        delete_pool(*args).value!
      end

      def fetch_profiles(algo: nil)
        result_list = get('/account/profile', params: { algo: algo })
        Monads.result_list_bind(result_list) { Profile.try(_1).to_monad }
      end

      def fetch_profiles!(*args)
        fetch_profiles(*args).value!
      end

      def fetch_profile(id:)
        get("/account/profile/#{id}").bind { Profile.try(_1).to_monad }
      end

      def fetch_profile!(*args)
        fetch_profile(*args).value!
      end
    end
  end
end
