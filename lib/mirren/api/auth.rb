require 'openssl'

module Mirren
  module Api
    class Auth
      def initialize(message)
        @message = message
        @secret = ENV['API_SECRET'] || ''
      end

      def call
        OpenSSL::HMAC.hexdigest('sha1', @secret, @message)
      end
    end
  end
end
