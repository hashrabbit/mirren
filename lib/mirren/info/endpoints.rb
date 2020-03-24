require 'mirren/api'

module Mirren
  module Info
    module Endpoints
      include Api

      def fetch_whoami
        Whoami.new(get('/whoami'))
      end

      def fetch_algos
        get('/info/algos').map { |e| Algorithm.new(e) }
      end

      def fetch_algo(name:)
        Algorithm.new(get("/info/algos/#{name}"))
      end
    end
  end
end
