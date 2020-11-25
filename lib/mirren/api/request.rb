require 'json'
require 'rest-client'

module Mirren
  module Api
    class Request
      include Dry::Monads[:result, :try]
      include Dry::Monads::Do.for(:call)
      extend Dry::Initializer

      param :host
      param :auth
      param :method
      param :request

      def call(path, get_params: {}, post_params: {})
        req_opts = request_opts(path, get_params, post_params)
        @response = yield perform(req_opts)
        body = yield parse(@response.body)
        Response.new(body).to_result
      rescue RestClient::Exception => e
        Failure(ClientError.new(e))
      end

      private

      def perform(opts)
        Try(RestClient::ExceptionWithResponse) { request.call(opts) }
          .to_result
          .or { Failure(ApiError.new(_1)) }
      end

      def parse(json)
        Try(JSON::ParserError) { JSON.parse(json) }
          .to_result
          .or { Failure(JsonError.new(_1)) }
      end

      def request_opts(path, get_params, post_params)
        {
          method: method,
          url: "#{host}#{path}",
          headers: Header.call(auth, path)
                         .merge(params: QueryParams.call(get_params)),
          payload: post_params && post_params.to_json
        }.compact
      end
    end
  end
end
