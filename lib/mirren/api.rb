require 'mirren/api/auth'
require 'mirren/api/header'
require 'mirren/api/request'

module Mirren
  module Api
    def get(path, params: {})
      Request.new(method: :get).call(path: path, get_params: params.compact)
    end

    def put(path, params: {})
      Request.new(method: :put).call(path: path, post_params: params.compact)
    end

    def delete(path)
      Request.new(method: :delete).call(path: path)
    end

    def valid_params!(params, klass)
      return if params.is_a?(klass)

      raise ParamsError.new(klass)
    end
  end
end
