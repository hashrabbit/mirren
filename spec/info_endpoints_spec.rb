require 'spec_helper'

module Mirren
  module Info
    RSpec.describe Endpoints do
      let(:request) { double }
      let(:client) { MockClient.new(Endpoints).call(request) }
      let(:response) do
        "{ \"success\": #{response_success?}," \
        "  \"data\": #{response_data} }"
      end
      let(:name) { 'sha256' }

      before do
        allow(request).to receive(:call) { Struct.new(:body).new(response) }
      end

      context 'when the underlying request returns without success' do
        include_context 'endpoint failures', {
          fetch_whoami: {},
          fetch_algos: {},
          fetch_algo: { name: 'sha256' }
        }
      end

      context 'when the underlying request succeeds' do
        let(:response_success?) { true }

        describe '#fetch_whoami' do
          let(:response_data) do
            <<-JSON
            {
              "userid": "3",
              "username": "whoami_username",
              "api_key": "whoami_api_key",
              "api_sign": "whoami_api_sign",
              "api_nonce": "7",
              "authed": true,
              "auth_mesage": "whoami_auth_mesage",
              "permissions": {
                "withdraw": "whoami_permissions_withdraw",
                "rent": "whoami_permissions_rent",
                "rigs": "whoami_permissions_rigs"
              }
            }
            JSON
          end

          it 'returns my access info' do
            who = client.fetch_whoami
            expect(who.value!).to be_a Whoami
          end
        end

        describe 'Algorithms' do
          let(:algo_json) do
            <<-JSON
            {
              "name": "algorithm_name_1",
              "display": "algorithm_display",
              "suggested_price": {
                "amount": "4.5",
                "currency": "algorithm_suggested_price_currency",
                "unit": "algorithm_suggested_price_unit"
              },
              "stats": {
                "available": {
                  "rigs": "3",
                  "hash": {
                    "hash": "7.0",
                    "unit": "stats_available_hash_unit",
                    "type": "stats_available_hash_type",
                    "nice": "stats_avaialable_hash_nice"
                  }
                },
                "rented": {
                  "rigs": "5",
                  "hash": {
                    "hash": "6.0",
                    "unit": "stats_rented_hash_unit",
                    "type": "stats_rented_hash_type",
                    "nice": "stats_rented_hash_nice"
                  }
                },
                "prices": {
                  "lowest": {
                    "amount": "1.0",
                    "currency": "stats_prices_lowest_currency",
                    "unit": "stats_prices_lowest_unit"
                  },
                  "last": {
                    "amount": "2.0",
                    "currency": "stats_prices_last_currency",
                    "unit": "stats_prices_last_unit"
                  },
                  "last_10": {
                    "amount": "3.0",
                    "currency": "stats_prices_last_10_currency",
                    "unit": "stats_prices_last_10_unit"
                  }
                }
              },
              "new": false,
              "hot": false,
              "hashtype": "algorithm_hashtype",
              "pool_option1": "algorithm_pool_option1"
            }
            JSON
          end

          describe '#fetch_algos' do
            let(:response_data) { "[#{algo_json}, #{algo_json}, #{algo_json}]" }
            it 'returns info for all Algorithms' do
              algos = client.fetch_algos.value!
              expect(algos.length).to eq 3
            end
          end

          describe '#fetch_algo(:name)' do
            let(:response_data) { algo_json }

            it 'returns detailed info for the specified Algo' do
              algo = client.fetch_algo(name: name).value!
              expect(algo).to be_an Algorithm
            end
          end
        end
      end
    end
  end
end
