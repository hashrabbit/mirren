require 'spec_helper'

module Mirren
  module Rentals
    RSpec.describe Endpoints do
      let(:request) { double }
      let(:client) { MockClient.new(Endpoints).call(request) }
      let(:response) do
        "{ \"success\": #{response_success?}," \
        "  \"data\": #{response_data} }"
      end

      before do
        allow(request).to receive(:call) { Struct.new(:body).new(response) }
      end

      context 'when the underlying request returns without success' do
        include_context 'endpoint failures', {
          fetch_rentals: { params: FoundParams.new(
            type: 'renter',
            algo: 'sha256',
            history: true,
            limit: 1
          ) },
          fetch_rental: { id: '1' },
          fetch_rental_pools: { id: '1' },
          create_rental: { params: Params.new(
            rig: 3,
            length: '7.0',
            profile: 9,
            currency: 'BTC'
          ) },
          add_rental_pool: { id: '1', params: PoolParams.new(
            priority: 3,
            host: 'host.domain',
            port: 3333,
            user: 'user',
            pass: 'pass'
          ) },
          delete_rental_pool: { id: '1', priority: '3' }
        }
      end

      context 'when the underlying request succeeds' do
        let(:response_success?) { true }
        describe '#fetch_rentals(:params)' do
          let(:params) do
            FoundParams.new(algo: 'sha256', history: true, limit: 1)
          end
          let(:response_data) do
            <<-JSON
            {
              "total": "3",
              "returned": "2",
              "start": "1",
              "limit": "4",
              "rentals": []
            }
            JSON
          end

          it 'filter my Rentals using FoundParams' do
            found = client.fetch_rentals(params: params).value!
            expect(found).to be_a Found
          end
        end

        describe '#fetch_rental(:id)' do
          let(:params) do
            FoundParams.new(algo: 'sha256', history: true, limit: 1)
          end
          let(:start_time) { Time.now }
          let(:end_time) { Time.now }
          let(:response_data) do
            <<-JSON
            {
              "id": "7",
              "owner": "rental_owner",
              "renter": "rental_renter",
              "hashrate": {
                "advertised": {
                  "hash": 1.0,
                  "type": "hashrate_advertised_type",
                  "nice": "hashrate_advertised_nice"
                },
                "average": {
                  "hash": 4.0,
                  "type": "hashrate_average_type",
                  "nice": "hashrate_average_nice"
                }
              },
              "price": {
                "type": "price_type",
                "advertised": "4.0",
                "paid": "3.3",
                "currency": "price_currency"
              },
              "price_converted": {
                "type": "price_converted_type",
                "advertised": "1.0",
                "paid": "2.0",
                "currency": "price_converted_currency"
              },
              "length": 7,
              "extended": 5,
              "start": "#{start_time}",
              "end": "#{end_time}",
              "rig": {
                "id": "1",
                "name": "rig_name",
                "owner": "rig_owner",
                "type": "rig_type",
                "status": {
                  "status": "rig_status",
                  "hours": "24",
                  "rented": true,
                  "online": true
                },
                "online": true,
                "xnonce": "yes",
                "ndevices": 8,
                "region": "rig_region",
                "rpi": 4.5,
                "suggested_diff": "100.0",
                "optimal_diff": {
                  "min": "50.0",
                  "max": "500.0"
                },
                "poolstatus": "rig_poolstatus",
                "extensions": true,
                "price": {
                  "type": "rig_price_type",
                  "BTC": {
                    "currency": "rig_price_BTC_currency",
                    "price": "100.0",
                    "hour": "12.0",
                    "minhrs": "24.0",
                    "maxhrs": "72.0",
                    "enabled": true
                  }
                },
                "minhours": "24",
                "maxhours": "72",
                "hashrate": {
                  "advertised": {
                    "hash": "100.0",
                    "type": "rig_hashrate_advertised_type",
                    "nice": "rig_hashrate_advertised_nice"
                  }
                },
                "available_status": "rig_available_status",
                "shorturl": "rig_shorturl"
              }
            }
            JSON
          end

          it 'returns details for the Rental' do
            rental = client.fetch_rental(id: '7').value!
            expect(rental).to be_a Rental
          end
        end
      end
    end
  end
end
