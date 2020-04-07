require 'spec_helper'

module Mirren
  module Accounts
    RSpec.describe Endpoints do
      let(:request) { double() }
      let(:client) { MockClient.new(Endpoints).call(request) }
      let(:response) { "{ \"success\": #{response_success?}, \"data\": #{response_data} }" }

      before do
        allow(request).to receive(:call) { Struct.new(:body).new(response) }
      end

      # TODO: Does the rest_client::request#execute raise exceptions, or just return {success: false}?
      context 'when the underlying request returns without success' do
        endpoint_list = {
          fetch_account: {},
          fetch_account_balance: {},
          fetch_pools: {},
          fetch_pool: {id: nil},
          create_pool: {params: PoolParams.new(
            type: 'sha256',
            name: '***Test Pool***',
            host: 'btc.pool.com',
            port: 3333,
            user: 'test-worker',
            pass: 'x'
          )},
          delete_pool: {id: nil},
          fetch_profiles: {algo: nil},
          fetch_profile: {id: nil}
        }

        context 'when the api response indicates a failed request' do
          let(:response_success?) { false }
          let(:response_data) { "{\"message\": \"Request failed\"}" }

          endpoint_list.each_pair do |method, kwargs|
            specify "#{method} returns a Failure of ApiError" do
              result = client.send(method, **kwargs)
              expect(result).to be_failure
              expect(result.flip.value!).to be_a ApiError
            end

            specify "#{method}! raises an ApiError" do
              expect { client.send("#{method}!", **kwargs) }.to raise_error(ApiError)
            end
          end
        end

        context 'when the underlying request returns bad json' do
          let(:response_success?) { true }
          let(:response_data) { "bad json" }

          endpoint_list.each_pair do |method, kwargs|
            specify "#{method} returns a Failure of JsonError" do
              result = client.send(method, **kwargs)
              expect(result).to be_failure
              expect(result.flip.value!).to be_a JsonError
            end

            specify "#{method}! raises a JsonError" do
              expect { client.send(:"#{method}!", **kwargs) }.to raise_error(JsonError)
            end
          end
        end

        context 'when the rest client throws an execption with a response code' do
          before do
            allow(request).to(receive(:call)).and_raise RestClient::ImATeapot
          end

          endpoint_list.each_pair do |method, kwargs|
            specify "#{method} returns a Failure of ApiError" do
              result = client.send(method, **kwargs)
              expect(result).to be_failure
              expect(result.flip.value!).to be_a ApiError
            end

            specify "#{method}! raises an ApiError" do
              expect { client.send("#{method}!", **kwargs) }.to raise_error(ApiError)
            end
          end
        end


        context 'when the underlying request throws an error without a response code' do
          before do
            allow(request).to(receive(:call)).and_raise RestClient::Exception
          end

          endpoint_list.each_pair do |method, kwargs|
            specify "#{method} returns a Failure of ClientError" do
              result = client.send(method, **kwargs)
              expect(result).to be_failure
              expect(result.flip.value!).to be_an ClientError
            end

            specify "#{method}! raises a ClientError" do
              expect { client.send("#{method}!", **kwargs) }.to raise_error(ClientError)
            end
          end
        end
      end

      context 'when the underlying request succeeds' do
        let(:response_success?) { true }
        context 'General Info' do
          describe '#fetch_account' do
            let(:response_data) do
              <<-JSON
                {
                  "username": "account_username",
                  "email": "account_email",
                  "withdraw": {
                    "BTC": {
                      "address": "account_withdraw_BTC_address",
                      "label": "account_withdraw_BTC_label",
                      "auto_pay_threshold": "account_withdraw_BTC_auto_pay_threshold",
                      "txfee": "account_withdraw_BTC_txfee"
                    }
                  },
                  "deposit": {
                    "BTC": {
                      "address": "account_deposit_BTC_address"
                    }
                  },
                  "notifications": {
                    "rental_comm": "yes",
                    "new_rental": "yes",
                    "offline": "yes",
                    "news": "yes",
                    "deposit": "yes"
                  },
                  "settings": {
                    "2factor_auth": "yes",
                    "live_data": "yes",
                    "public_profile": "yes"
                  }
                }
              JSON
            end
            it 'returns my account info' do
              acct = client.fetch_account
              expect(acct.value!).to be_an Account
            end

            context 'when called with the raise helper' do
              it 'returns my account info' do
                acct = client.fetch_account!
                expect(acct).to be_an Account
              end
            end
          end

          describe '#fetch_account_balance' do
            let(:response_data) do
              <<-JSON
                {
                  "BTC": {
                    "confirmed": "0.0",
                    "unconfirmed": "0.0"
                  },
                  "BCH": {
                    "confirmed": "0.0",
                    "unconfirmed": "0.0"
                  },
                  "LTC": {
                    "confirmed": "0.0",
                    "unconfirmed": "0.0"
                  },
                  "ETH": {
                    "confirmed": "0.0",
                    "unconfirmed": "0.0"
                  },
                  "DASH": {
                    "confirmed": "0.0",
                    "unconfirmed": "0.0"
                  }
                }
              JSON
            end
            it 'returns my account balance' do
              bal = client.fetch_account_balance.value!
              expect(bal.BTC.confirmed).to be == 0.0
            end

            context 'when called with the raise helper' do
              it 'returns my account balance' do
                bal = client.fetch_account_balance!
                expect(bal.BTC.confirmed).to be == 0.0
              end
            end
          end
        end

        context 'Pools' do
          describe '#fetch_pools' do
            let(:response_data) do
              <<-JSON
                [
                  {
                    "id": "0",
                    "priority": 1,
                    "type": "pool_type",
                    "name": "pool_name",
                    "host": "pool_host",
                    "port": "3333",
                    "user": "pool_user",
                    "pass": "pool_pass"
                  },
                  {
                    "id": "1",
                    "priority": 1,
                    "type": "pool_type",
                    "name": "pool_name",
                    "host": "pool_host",
                    "port": "3333",
                    "user": "pool_user",
                    "pass": "pool_pass",
                    "notes": "pool_notes"
                  },
                  {
                    "id": "2",
                    "priority": 1,
                    "type": "pool_type",
                    "name": "pool_name",
                    "host": "pool_host",
                    "port": "3333",
                    "user": "pool_user",
                    "pass": "pool_pass",
                    "pool_option1": "pool_pool_option1"
                  }
                ]
              JSON
            end

            it 'returns a list of saved Pools' do
              pools = client.fetch_pools.value!
              expect(pools.size).to eq 3
            end
            context 'when called with the raise helper' do
              it 'returns a list of saved Pools' do
                pools = client.fetch_pools!
                expect(pools.size).to eq 3
              end
            end
          end

          describe '#fetch_pool(:id)' do
            let(:response_data) do
              <<-JSON
                {
                  "id": "1",
                  "priority": 1,
                  "type": "pool_type",
                  "name": "pool_name",
                  "host": "pool_host",
                  "port": "3333",
                  "user": "pool_user",
                  "pass": "pool_pass",
                  "notes": "pool_notes"
                }
              JSON
            end

            it 'returns details for the Pool specified by :id' do
              pool = client.fetch_pool(id: "1").value!
              expect(pool).to be_a Pool
            end

            context 'when called with the raise helper' do
              it 'returns details for the Pool specified by :id' do
                pool = client.fetch_pool!(id: "1")
                expect(pool).to be_a Pool
              end
            end
          end

          describe '#create_pool(:params)' do
            let(:pool_params) {
              PoolParams.new(
                type: 'sha256',
                name: '***Test Pool***',
                host: 'btc.pool.com',
                port: 3333,
                user: 'test-worker',
                pass: 'x'
              )
            }
            let(:response_data) do
              <<-JSON
                {
                  "id": "0",
                  "priority": 1,
                  "type": "sha256",
                  "name": "***Test Pool***",
                  "host": "btc.pool.com",
                  "port": "3333",
                  "user": "test-worker",
                  "pass": "x"
                }
              JSON
            end

            it 'create a new Pool resource, using supplied PoolParams' do
              create_response = client.create_pool(params: pool_params).value!
              expect(create_response["id"].to_i).to eq 0
            end

            context 'when called with the raise helper' do
              it 'create a new Pool resource, using supplied PoolParams' do
                create_response = client.create_pool!(params: pool_params)
                expect(create_response["id"].to_i).to eq 0
              end
            end
          end

          describe '#delete_pool(:id)' do
            let(:pool_id) { "3" }
            let(:response_data) do
              <<-JSON
                {
                  "id": "#{pool_id}",
                  "message": "Deleted"
                }
              JSON
            end

            it 'removes a Pool resource, using supplied id' do
              delete_response = client.delete_pool(id: pool_id).value!
              expect(delete_response).to include('id' => pool_id, 'message' => 'Deleted')
            end

            context 'when called with the raise helper' do
              it 'removes a Pool resource, using supplied id' do
                delete_response = client.delete_pool!(id: pool_id)
                expect(delete_response).to include('id' => pool_id, 'message' => 'Deleted')
              end
            end
          end
        end

        context 'Profiles' do
          let(:algo) do
            <<-JSON
              {
                "name": "algo_name",
                "display": "algo_display",
                "suggested_price": {
                  "amount": "0.0",
                  "currency": "algo_suggested_price_currency",
                  "unit": "algo_suggested_price_unit"
                },
                "stats": {
                  "available": {
                    "rigs": "3",
                    "hash": {
                      "hash": "3.0",
                      "unit": "available_hash_unit",
                      "type": "available_hash_type",
                      "nice": "available_hash_nice"
                    }
                  },
                  "rented": {
                    "rigs": "6",
                    "hash": {
                      "hash": "7.0",
                      "unit": "rented_hash_unit",
                      "type": "rented_hash_type",
                      "nice": "rented_hash_nice"
                    }
                  },
                  "prices": {
                    "lowest": {
                      "amount": "0.0",
                      "currency": "algo_suggested_price_currency",
                      "unit": "algo_suggested_price_unit"
                    },
                    "last": {
                      "amount": "0.0",
                      "currency": "algo_suggested_price_currency",
                      "unit": "algo_suggested_price_unit"
                    },
                    "last_10": {
                      "amount": "0.0",
                      "currency": "algo_suggested_price_currency",
                      "unit": "algo_suggested_price_unit"
                    }
                  }
                },
                "new": false,
                "hot": false,
                "hashtype": "algo_hashtype",
                "pool_option1": "algo_pool_option1"
              }
            JSON
          end

          describe '#fetch_profiles([:algo])' do
            let(:response_data) do
              <<-JSON
                [
                  {
                    "id": "0",
                    "name": "profile_name",
                    "algo": #{algo},
                    "pools": [],
                    "default": true
                  },
                  {
                    "id": "1",
                    "name": "profile_name",
                    "algo": #{algo},
                    "pools": [],
                    "default": true
                  },
                  {
                    "id": "2",
                    "name": "profile_name",
                    "algo": #{algo},
                    "pools": [],
                    "default": true
                  }
                ]
              JSON
            end

            it 'returns list of profiles, optionally filtered by :algo' do
              profiles = client.fetch_profiles(algo: nil).value!
              expect(profiles.length).to eq 3
            end

            context 'when called with the raise helper' do
              it 'returns list of profiles, optionally filtered by :algo' do
                profiles = client.fetch_profiles!(algo: nil)
                expect(profiles.length).to eq 3
              end
            end
          end

          describe '#fetch_profile(:id)' do
            let(:response_data) do
              <<-JSON
                {
                  "id": "1",
                  "name": "profile_name",
                  "algo": #{algo},
                  "pools": [],
                  "default": true
                }
              JSON
            end

            it 'returns details for the Profile specified by :id' do
              profile = client.fetch_profile(id: '1').value!
              expect(profile).to be_a Profile
            end

            context 'when called with the raise helper' do
              it 'returns details for the Profile specified by :id' do
                profile = client.fetch_profile!(id: '1')
                expect(profile).to be_a Profile
              end
            end
          end
        end
      end
    end
  end
end
