module Mirren
  module Api
    class Header
      def initialize(path)
        @path = path
        @key = ENV['API_KEY']
      end

      def call
        {
          content_type: :json,
          'x-api-key': @key,
          'x-api-nonce': nonce,
          'x-api-sign': Auth.new("#{@key}#{nonce}#{@path}").call
        }
      end

      private

      def nonce
        @nonce ||= (Time.now.to_f * 1000).truncate
      end
    end
  end
end
