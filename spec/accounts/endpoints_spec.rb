require 'spec_helper'

module Mirren
  module Accounts
    RSpec.describe Endpoints do
      let(:client) { Class.new.tap { |c| c.extend Endpoints } }

      context 'General Info' do
        describe '#fetch_account' do
          it 'returns my account info' do
            acct = client.fetch_account
            expect(acct.email).to eq 'amami@amamisystems.com'
          end
        end

        describe '#fetch_account_balance' do
          it 'returns my account balance' do
            bal = client.fetch_account_balance
            expect(bal.BTC.confirmed).to be >= 0.0
          end
        end
      end

      context 'Pools' do
        let(:pools) { client.fetch_pools }

        describe '#fetch_pools' do
          it 'returns list of saved Pools' do
            expect(pools.size).to be > 0
          end
        end

        describe '#fetch_pool(:id)' do
          it 'returns details for the Pool specified by :id' do
            pool = client.fetch_pool(id: pools[0].id)
            expect(pool.priority).to eq 0
          end
        end

        describe '#create_pool(:params)' do
          let(:params) {
            PoolParams.new(
              type: 'sha256',
              name: '***Test Pool***',
              host: 'btc.pool.com',
              port: 3333,
              user: 'test-worker',
              pass: 'x'
            )
          }

          it 'create a new Pool resource, using supplied PoolParams' do
            pool_id = client.create_pool(params: params)['id']
            expect(pool_id.to_i).to be > 0
            deleted = client.delete_pool(id: pool_id)
            expect(deleted).to include('id' => pool_id, 'message' => 'Deleted')
          end
        end
      end

      context 'Profiles' do
        let(:algo) { 'sha256ab' }
        let(:profiles) { client.fetch_profiles(algo: algo) }

        describe '#fetch_profiles([:algo])' do
          it 'returns list of profiles, optionally filtered by :algo' do
            expect(profiles).not_to be_empty
          end
        end

        describe '#fetch_profile(:id)' do
          it 'returns details for the Profile specified by :id' do
            id = profiles[0].id
            profile = client.fetch_profile(id: id)
            expect(profile.algo.name).to eq algo
          end
        end
      end
    end
  end
end
