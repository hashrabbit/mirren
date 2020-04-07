require 'json'
require 'rest-client'

module Mirren
  module Api
    class Request
      attr_reader :method, :host, :path, :get_params, :post_params

      def initialize(method:, request:)
        @host = 'https://www.miningrigrentals.com/api/v2'
        @method = method
        @request = request
      end

      def call(path:, get_params: {}, post_params: {})
        @path = path
        @get_params = get_params
        @post_params = post_params

        if body['success']
          Monads::Success.new(body['data'])
        else
          Monads::Failure.new(ApiError.new(body['data']['message']))
        end

      rescue RestClient::ExceptionWithResponse => e
        Monads::Failure.new(ApiError.new(e))
      rescue RestClient::Exception => e
        Monads::Failure.new(ClientError.new(e))
      rescue JSON::ParserError => e
        Monads::Failure.new(JsonError.new(e))
      end

      def response
        @response ||= @request.call(request_args)
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
