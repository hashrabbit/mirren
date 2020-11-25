module Mirren
  module Api
    class QueryParams
      def self.call params_hsh
        params_hsh.map { rewrite(_1, _2) }.to_h
      end

      private

      def self.rewrite(key, value)
        rewritten_value =
          if value.is_a?(Hash)
            value.map { rewrite(_1, _2) }.to_h
          elsif value.is_a?(Array)
            value.map { rewrite(nil, _1) }
          elsif value == true
            1
          elsif value == false
            0
          else
            value
          end
        key.nil? ? rewritten_value : [key, rewritten_value]
      end
    end
  end
end
