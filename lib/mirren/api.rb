require 'mirren/api/auth'
require 'mirren/api/header'
require 'mirren/api/request'

module Mirren
  module Api
    def get(path, params: {})
      Request.new(method: :get, request: request).call(path: path, get_params: params.compact)
    end

    def put(path, params: {})
      Request.new(method: :put, request: request).call(path: path, post_params: params.compact)
    end

    def delete(path)
      Request.new(method: :delete, request: request).call(path: path)
    end

    def validate_params(params, klass)
      if params.is_a?(klass)
        Monads::Success.new(params)
      else
        Monads::Failure.new(ParamsError.new(klass))
      end
    end

    def valid_params!(params, klass)
      return if params.is_a?(klass)

      raise ParamsError.new(klass)
    end

    def request
      raise NotImplementedError
      # RestClient::Request.execute
    end
  end
end
