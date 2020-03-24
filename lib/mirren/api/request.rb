require 'json'
require 'rest-client'

module Mirren
  module Api
    class Request
      attr_reader :method, :host, :path, :get_params, :post_params

      def initialize(method:)
        @host = 'https://www.miningrigrentals.com/api/v2'
        @method = method
      end

      def call(path:, get_params: {}, post_params: {})
        @path = path
        @get_params = get_params
        @post_params = post_params
        raise ApiError.new(body['data']['message']) unless body['success']

        body['data']
      end

      def response
        @response ||= RestClient::Request.execute(request_args)
      end

      def body
        @body ||= JSON.parse(response.body)
      end

      private

      def request_args
        {
          method: method,
          url: "#{host}#{path}",
          headers: Header.new(path).call.merge(params: get_params),
          payload: post_params && post_params.to_json
        }.compact
      end
    end
  end
end
