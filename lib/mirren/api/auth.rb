require 'openssl'

module Mirren
  module Api
    class Auth
      attr_reader :api_key, :api_secret

      def initialize(key, secret)
        @api_key = key
        @api_secret = secret
      end

      def call(nonce, path)
        OpenSSL::HMAC.hexdigest('sha1', api_secret, "#{api_key}#{nonce}#{path}")
      end
    end
  end
end
