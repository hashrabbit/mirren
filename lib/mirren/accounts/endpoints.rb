require 'mirren/api'

module Mirren
  module Accounts
    module Endpoints
      include Api

      def fetch_account
        get('/account').bind do |acct|
          acct['settings'].tap do |h|
            h['two_factor'] = h.delete('2factor_auth')
          end

          Account.try(acct)
                 .to_monad
                 .extend(ResultExt)
                 .fmap_left { UnmarshalError.new(_1) }
        end
      end

      def fetch_account!
        fetch_account
          .extend(ResultExt)
          .unwrap_result!
      end

      def fetch_account_balance
        get('/account/balance').bind do |balance|
          Balance.try(balance)
                 .to_monad
                 .extend(ResultExt)
                 .fmap_left { UnmarshalError.new(_1) }
        end
      end

      def fetch_account_balance!
        fetch_account_balance
          .extend(ResultExt)
          .unwrap_result!
      end

      def fetch_pools
        get('/account/pool')
          .extend(ResultExt)
          .traverse do |pool|
            Pool.try(pool)
                .to_monad
                .extend(ResultExt)
                .fmap_left { UnmarshalError.new(_1) }
          end
      end

      def fetch_pools!
        fetch_pools
          .extend(ResultExt)
          .unwrap_result!
      end

      def fetch_pool(id:)
        get("/account/pool/#{id}").bind do |pool|
          Pool.try(pool)
              .to_monad
              .extend(ResultExt)
              .fmap_left { UnmarshalError.new(_1) }
        end
      end

      def fetch_pool!(kwargs)
        fetch_pool(**kwargs)
          .extend(ResultExt)
          .unwrap_result!
      end

      def create_pool(params: nil)
        valid_params!(params, PoolParams)
        put('/account/pool', params: params.to_h)
      end

      def create_pool!(kwargs)
        create_pool(**kwargs)
          .extend(ResultExt)
          .unwrap_result!
      end

      def delete_pool(id:)
        delete("/account/pool/#{id}")
      end

      def delete_pool!(kwargs)
        delete_pool(**kwargs)
          .extend(ResultExt)
          .unwrap_result!
      end

      def fetch_profiles(algo: nil)
        get('/account/profile', params: { algo: algo })
          .extend(ResultExt)
          .traverse do |profile|
            Profile.try(profile)
                   .to_monad
                   .extend(ResultExt)
                   .fmap_left { UnmarshalError.new(_1) }
          end
      end

      def fetch_profiles!(kwargs)
        fetch_profiles(**kwargs)
          .extend(ResultExt)
          .unwrap_result!
      end

      def fetch_profile(id:)
        get("/account/profile/#{id}").bind do |profile|
          Profile.try(profile)
                 .to_monad
                 .extend(ResultExt)
                 .fmap_left { UnmarshalError.new(_1) }
        end
      end

      def fetch_profile!(kwargs)
        fetch_profile(**kwargs)
          .extend(ResultExt)
          .unwrap_result!
      end
    end
  end
end
