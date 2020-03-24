require 'spec_helper'

module Mirren
  module Rentals
    RSpec.describe Endpoints do
      let(:client) { Class.new.tap { |c| c.extend Endpoints } }
      let(:params) {
        FoundParams.new(algo: 'sha256', history: true, limit: 1)
      }
      let(:found) { client.fetch_rentals(params: params) }

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
