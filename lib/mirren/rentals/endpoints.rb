require 'mirren/api'

module Mirren
  module Rentals
    module Endpoints
      include Api

      def fetch_rentals(params: nil)
        valid_params!(params, FoundParams)

        get('/rental', params: params.to_h).bind do |fields|
          Found.try(fields)
            .to_monad.extend(ResultExt)
            .fmap_left { UnmarshalError.new(_1) }
        end
      end

      def fetch_rentals!(kwargs)
        fetch_rentals(**kwargs)
          .extend(ResultExt)
          .unwrap_result!
      end

      def fetch_rental(id:)
        get("/rental/#{id}").bind do |fields|
          Rental.try(fields)
            .to_monad.extend(ResultExt)
            .fmap_left { UnmarshalError.new(_1) }
        end
      end

      def fetch_rental!(kwargs)
        fetch_rental(**kwargs)
          .extend(ResultExt)
          .unwrap_result!
      end

      def fetch_rental_pools(id:)
        get("/rental/#{id}/pool").fmap { _1['pools'] }
          .extend(ResultExt)
          .traverse do |pool|
            Pool.try(pool)
              .to_monad.extend(ResultExt)
              .fmap_left { UnmarshalError.new(_1) }
          end
      end

      def fetch_rental_pools!(kwargs)
        fetch_rental_pools(**kwargs)
          .extend(ResultExt)
          .unwrap_result!
      end

      def create_rental(params: nil)
        valid_params!(params, Params)

        put('/rental', params: params.to_h).bind do |fields|
          Rental.try(fields)
            .to_monad.extend(ResultExt)
            .fmap_left { UnmarshalError.new(_1) }
        end
      end

      def create_rental!(kwargs)
        create_rental(**kwargs)
          .extend(ResultExt)
          .unwrap_result!
      end

      def add_rental_pool(id:, params: nil)
        valid_params!(params, PoolParams)

        put("/rental/#{id}/pool", params: params.to_h)
      end

      def add_rental_pool!(kwargs)
        add_rental_pool(**kwargs)
          .extend(ResultExt)
          .unwrap_result!
      end

      def delete_rental_pool(id:, priority:)
        delete("/rental/#{id}/pool/#{priority}")
      end

      def delete_rental_pool!(kwargs)
        delete_rental_pool(**kwargs)
          .extend(ResultExt)
          .unwrap_result!
      end
    end
  end
end
