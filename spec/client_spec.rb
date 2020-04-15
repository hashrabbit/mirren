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
      who = client.fetch_account_balance
      expect(who).not_to be_success
    end
  end
end
