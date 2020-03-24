require 'spec_helper'

module Mirren
  module Rigs
    RSpec.describe Endpoints do
      let(:client) { Class.new.tap { |c| c.extend Endpoints } }
      let(:params) {
        Params.new(type: 'sha256ab', count: 10, rpi: { min: 100 })
      }
      let(:full_params) {
        Params.new(
          type: 'sha256', count: 10, rpi: { min: 100 },
          minhours: { max: 24 }, hash: { min: 12, max: 16, type: 'th' }
        )
      }
      let(:found) { client.fetch_rigs(params: full_params) }
      let(:xnonce) { found.records.select(&:xnonce) }

      describe '#fetch_rigs(:params)' do
        it 'filter Rigs based on :type and additionally supplied Params' do
          expect(found.total).to be > 0
        end
      end

      describe '#fetch_rig(:id)' do
        it 'returns details for the Rig specified by :id' do
          rig = client.fetch_rig(id: found.records[0].id)
          expect(rig.rpi).to eq 100.0
        end
      end
    end
  end
end
