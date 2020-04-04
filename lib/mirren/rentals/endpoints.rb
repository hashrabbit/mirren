require 'mirren/api'

module Mirren
  module Rentals
    module Endpoints
      include Api

      def fetch_rentals(params: nil)
        valid_params!(params, FoundParams)

        fields = get('/rental', params: params.to_h)
        Found.new(fields)
      end

      def fetch_rental(id:)
        fields = get("/rental/#{id}")
        Rental.new(fields)
      end

      def fetch_rental_pools(id:)
        get("/rental/#{id}/pool")['pools'].map { |e| Pool.new(e) }
      end

      def create_rental(params: nil)
        valid_params!(params, Params)

        fields = put('/rental', params: params.to_h)
        Rental.new(fields)
      end

      def add_rental_pool(id:, params: nil)
        valid_params!(params, PoolParams)

        put("/rental/#{id}/pool", params: params.to_h)
      end

      def delete_rental_pool(id:, priority:)
        delete("/rental/#{id}/pool/#{priority}")
      end
    end
  end
end
