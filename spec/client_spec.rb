require 'spec_helper'

module Mirren
  # These RSpec examples should only be used if you want to verify that you
  # have valid API credientials. If you set either :skip value to false, that
  # example will attempt to make a "live" connection to the MiningRigRentals.
  RSpec.describe Client do
    it 'connects with valid credentials', :skip => true do
      client = Client.new
      who = client.fetch_whoami
      expect(who).to be_success
      expect(who.value!).to be_a(Info::Whoami)
    end

    it 'fails to connect with invalid credentials', :skip => true do
      client = Client.new(api_secret: 'invalid')
      pools = client.fetch_pools
      expect(pools).not_to be_success
      expect(pools.failure).to be_an(ApiError)
    end

    it 'fails to retrieve a resource with an invalid :id', :skip => true do
      client = Client.new
      pool = client.fetch_pool(id: 1)
      expect(pool).not_to be_success
      expect(pool.failure).to be_an(ApiError)
    end
  end
end
