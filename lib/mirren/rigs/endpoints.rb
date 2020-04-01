require 'mirren/api'

module Mirren
  module Rigs
    module Endpoints
      include Api

      def fetch_rigs(params: nil)
        valid_params!(params, Params)

        fields = get('/rig', params: params.to_h)
        Found.new(fields)
      end

      def fetch_rig(id:)
        fields = get("/rig/#{id}")
        Rig.new(fields)
      end
    end
  end
end
