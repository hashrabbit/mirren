require 'mirren/api/auth'
require 'mirren/api/header'
require 'mirren/api/response'
require 'mirren/api/request'

module Mirren
  module Api
    def get(path, params: {})
      Request.new(host, auth, :get, request)
             .call(path, get_params: params.compact)
    end

    def put(path, params: {})
      Request.new(host, auth, :put, request)
             .call(path, post_params: params.compact)
    end

    def delete(path)
      Request.new(host, auth, :delete, request)
             .call(path)
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
