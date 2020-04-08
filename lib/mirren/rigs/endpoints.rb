require 'mirren/api'

module Mirren
  module Rigs
    module Endpoints
      include Api

      def fetch_rigs(params: nil)
        valid_params!(params, Params)

        get('/rig', params: params.to_h).bind do |fields|
          Found.try(fields)
               .to_monad
               .extend(ResultExt)
               .fmap_left { UnmarshalError(_1) }
        end
      end

      def fetch_rigs!(kwargs)
        fetch_rigs(**kwargs)
          .extend(ResultExt)
          .unwrap_result!
      end

      def fetch_rig(id:)
        get("/rig/#{id}").bind do |fields|
          Rig.try(fields)
             .to_monad
             .extend(ResultExt)
             .fmap_left { UnmarshalError(_1) }
        end
      end

      def fetch_rig!(kwargs)
        fetch_rig(**kwargs)
          .extend(ResultExt)
          .unwrap_result!
      end
    end
  end
end
