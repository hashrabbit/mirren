require 'mirren/api'

module Mirren
  module Info
    module Endpoints
      include Api

      def fetch_whoami
        fields = get('/whoami')
        Whoami.new(fields)
      end

      def fetch_algos
        get('/info/algos').map { |e| Algorithm.new(e) }
      end

      def fetch_algo(name:)
        fields = get("/info/algos/#{name}")
        Algorithm.new(fields)
      end
    end
  end
end
