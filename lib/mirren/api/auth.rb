require 'openssl'

module Mirren
  module Api
    class Auth
      extend Dry::Initializer

      param :api_key
      param :api_secret

      def call(nonce, path)
        OpenSSL::HMAC.hexdigest('sha1', api_secret, "#{api_key}#{nonce}#{path}")
      end
    end
  end
end
