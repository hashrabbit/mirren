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
        Monads.unwrap_result!(fetch_account)
      end

      def fetch_account_balance
        fields = get('/account/balance').bind { Balance.try(_1).to_monad }
      end

      def fetch_account_balance!
        Monads.unwrap_result!(fetch_account_balance)
      end

      def fetch_pools
        result_array = get('/account/pool')
        Monads.traverse_results(result_array) { Pool.try(_1).to_monad }
      end

      def fetch_pools!
        Monads.unwrap_result!(fetch_pools)
      end

      def fetch_pool(id:)
        get("/account/pool/#{id}").bind { Pool.try(_1).to_monad }
      end

      def fetch_pool!(kwargs)
        Monads.unwrap_result!(fetch_pool(**kwargs))
      end

      def create_pool(params: nil)
        valid_params!(params, PoolParams)

        put('/account/pool', params: params.to_h)
      end

      def create_pool!(kwargs)
        Monads.unwrap_result!(create_pool(**kwargs))
      end

      def delete_pool(id:)
        delete("/account/pool/#{id}")
      end

      def delete_pool!(kwargs)
        Monads.unwrap_result!(delete_pool(**kwargs))
      end

      def fetch_profiles(algo: nil)
        result_array = get('/account/profile', params: { algo: algo })
        Monads.traverse_results(result_array) { Profile.try(_1).to_monad }
      end

      def fetch_profiles!(kwargs)
        Monads.unwrap_result!(fetch_profiles(**kwargs))
      end

      def fetch_profile(id:)
        get("/account/profile/#{id}").bind { Profile.try(_1).to_monad }
      end

      def fetch_profile!(kwargs)
        Monads.unwrap_result!(fetch_profile(**kwargs))
      end
    end
  end
end
