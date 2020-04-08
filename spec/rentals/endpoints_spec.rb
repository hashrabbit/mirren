require 'spec_helper'

module Mirren
  module Rentals
    RSpec.describe Endpoints do
      let(:request) { double() }
      let(:client) { MockClient.new(Endpoints).call(request) }
      let(:response) { "{ \"success\": #{response_success?}, \"data\": #{response_data} }" }

      before do
        allow(request).to receive(:call) { Struct.new(:body).new(response) }
      end

      context 'when the underlying request returns without success' do
        include_context 'endpoint failures', {
          fetch_rentals: {params: FoundParams.new({
            type: 'renter',
            algo: 'sha256',
            history: true,
            limit: 1
          })},
          fetch_rental: {id: '1'},
          fetch_rental_pools: {id: '1'},
          create_rental: {params: Params.new({
            rig: 3,
            length: '7.0',
            profile: 9,
            currency: 'BTC'
          })},
          add_rental_pool: {id: '1', params: PoolParams.new({
            priority: 3,
            host: 'host.domain',
            port: 3333,
            user: 'user',
            pass: 'pass'
          })},
          delete_rental_pool: {id: '1', priority: '3'}
        }
      end

      #let(:params) {
      #  FoundParams.new(algo: 'sha256', history: true, limit: 1)
      #}
      # let(:found) { client.fetch_rentals(params: params) }

      describe '#fetch_rentals(:params)' do
        it 'filter my Rentals using FoundParams' do
          expect(found.total).to be > 0
        end
      end

      describe '#fetch_rental(:id)' do
        it 'returns details for the Rental specified by :id' do
          rental = client.fetch_rental(id: found.rentals[0].id)
          expect(rental.rig.type).to eq 'sha256'
        end
      end
    end
  end
end
