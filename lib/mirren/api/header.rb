module Mirren
  module Api
    class Header
      def self.call(auth, path)
        nonce = (Time.now.to_f * 1000).truncate
        {
          content_type: :json,
          'x-api-key': auth.api_key,
          'x-api-nonce': nonce,
          'x-api-sign': auth.call(nonce, path)
        }
      end
    end
  end
end
