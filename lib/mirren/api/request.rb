require 'json'
require 'rest-client'

module Mirren
  module Api
    class Request
      include Dry::Monads[:result]

      attr_reader :host, :auth, :method, :request, :response

      def initialize(host, auth, method, request)
        @host = host
        @auth = auth
        @method = method
        @request = request
      end

      def call(path, get_params: {}, post_params: {})
        body = JSON.parse(
          response(path, get_params, post_params).body
        )
        return Success(body['data']) if body['success']

        Failure(ApiError.new(body['data']['message']))
      rescue RestClient::ExceptionWithResponse => e
        Failure(ApiError.new(e))
      rescue RestClient::Exception => e
        Failure(ClientError.new(e))
      rescue JSON::ParserError => e
        Failure(JsonError.new(e))
      end

      private

      def response(path, get_params, post_params)
        @response ||= request.call(
          {
            method: method,
            url: "#{host}#{path}",
            headers: Header.call(auth, path).merge(params: get_params),
            payload: post_params && post_params.to_json
          }.compact
        )
      end
    end
  end
end
