require 'mirren/api/auth'
require 'mirren/api/header'
require 'mirren/api/request'

module Mirren
  module Api
    def get(path, params: {})
      Request.new(method: :get, request: request)
             .call(path: path, get_params: params.compact)
    end

    def put(path, params: {})
      Request.new(method: :put, request: request)
             .call(path: path, post_params: params.compact)
    end

    def delete(path)
      Request.new(method: :delete, request: request)
             .call(path: path)
    end

    def valid_params!(params, klass)
      return if params.is_a?(klass)

      raise ArgumentError, "Argument must be a #{klass}"
    end

    def request
      # RestClient::Request.execute
      raise NotImplementedError
    end
  end
end
