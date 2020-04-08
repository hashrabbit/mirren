require 'mirren/api'

module Mirren
  module Info
    module Endpoints
      include Api

      def fetch_whoami
        get('/whoami').bind do |whoami|
          Whoami.try(whoami)
            .to_monad.extend(ResultExt)
            .fmap_left { UnmarshalError.new(_1) }
        end
      end

      def fetch_whoami!
        fetch_whoami
          .extend(ResultExt)
          .unwrap_result!
      end

      def fetch_algos
        get('/info/algos')
          .extend(ResultExt)
          .traverse do |algo|
            Algorithm.try(algo)
              .to_monad.extend(ResultExt)
              .fmap_left { UnmarshalError.new(_1) }
          end
      end

      def fetch_algos!
        fetch_algos
          .extend(ResultExt)
          .unwrap_result!
      end

      def fetch_algo(name:)
        get("/info/algos/#{name}").bind do |algo|
          Algorithm.try(algo)
            .to_monad.extend(ResultExt)
            .fmap_left { UnmarshalError.new(_1) }
        end
      end

      def fetch_algo!(kwargs)
        fetch_algo(**kwargs)
          .extend(ResultExt)
          .unwrap_result!
      end
    end
  end
end
