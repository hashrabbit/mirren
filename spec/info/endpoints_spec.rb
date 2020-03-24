require 'spec_helper'

module Mirren
  module Info
    RSpec.describe Endpoints do
      context 'for a valid API Key and Secret' do
        let(:client) { Mirren::Client.new }
        let(:name) { 'sha256' }

        describe '#fetch_whoami' do
          it 'returns my access info' do
            who = client.fetch_whoami
            expect(who.authed).to eq true
            expect(who.username).to eq 'amami'
          end
        end

        describe '#fetch_algos' do
          it 'returns info for all Algorithms' do
            algos = client.fetch_algos
            expect(algos.map(&:name)).to include(name)
          end
        end

        describe '#fetch_algo(:name)' do
          it 'returns detailed info for the specified Algo' do
            algo = client.fetch_algo(name: name)
            expect(algo.stats.available.rigs).to be > 0
          end
        end
      end
    end
  end
end
