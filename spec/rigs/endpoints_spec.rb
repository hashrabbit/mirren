require 'spec_helper'

module Mirren
  module Rigs
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
          fetch_rigs: { params: Params.new(
            type: 'sha256ab',
            count: 10,
            rpi: { min: 100 }
          ) },
          fetch_rig: { id: '3' }
        }
      end

      context 'when the underlying request succeeds' do
        let(:response_success?) { true }
        describe '#fetch_rigs(:params)' do
          let(:full_params) do
            Params.new(
              type: 'sha256', count: 10, rpi: { min: 100 },
              minhours: { max: 24 }, hash: { min: 12, max: 16, type: 'th' }
            )
          end
          let(:response_data) do
            <<-JSON
            {
              "offset": "3",
              "count": "10",
              "total": "100",
              "stats": {
                "available": {
                  "rigs": "3",
                  "hash": {
                    "hash": "10.0",
                    "unit": "stats_available_rigs_unit",
                    "type": "stats_available_rigs_type",
                    "nice": "stats_available_rigs_nice"
                  }
                },
                "rented": {
                  "rigs": "6",
                  "hash": {
                    "hash": "20.0",
                    "unit": "stats_rented_rigs_unit",
                    "type": "stats_rented_rigs_type",
                    "nice": "stats_rented_rigs_nice"
                  }
                },
                "prices": {
                  "lowest": "10.0",
                  "last_10": "20.0",
                  "last": "25.0"
                }
              },
              "records": []
            }
            JSON
          end

          it 'filter Rigs based on :type and additionally supplied Params' do
            found = client.fetch_rigs(params: full_params).value!
            expect(found).to be_a Found
          end
        end

        describe '#fetch_rig(:id)' do
          let(:response_data) do
            <<-JSON
            {
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
                  },
                  "last_5min": {
                    "hash": "200.0",
                    "type": "rig_hashrate_last_5min_type",
                    "nice": "rig_hashrate_last_5min_nice"
                  },
                  "last_15min": {
                    "hash": "300.0",
                    "type": "rig_hashrate_last_15min_type",
                    "nice": "rig_hashrate_last_15min_nice"
                  },
                  "last_30min": {
                    "hash": "300.0",
                    "type": "rig_hashrate_last_30min_type",
                    "nice": "rig_hashrate_last_30min_nice"
                  }
                },
                "shorturl": "rig_shorturl",
                "description": "rig_description"
              }
            JSON
          end

          it 'returns details for the Rig specified by :id' do
            rig = client.fetch_rig(id: '3').value!
            expect(rig).to be_a Rig
          end
        end
      end
    end
  end
end
