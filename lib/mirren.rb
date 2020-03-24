require 'dry-struct'

module Types
  include Dry.Types()
  NilOrString = Types::Nil | Types::String
  FloatString = Types.Constructor(Float) { |v| v.to_f }
  IntString = Types.Constructor(Integer) { |v| v.to_i }
  YesBool = Types.Constructor(Bool) { |v| v.downcase == 'yes' ? true : false }
  HashTypes = Types::String.enum('hash', 'kh', 'mh', 'gh', 'th')
end

module Mirren
  Error = Class.new(StandardError)
  class ApiError < Error
    def initialize(message)
      super("API Error: #{message}")
    end
  end

  class ParamsError < Error
    def initialize(klass)
      super("Params Error: You must supply a #{klass} to this API method")
    end
  end

  BaseStruct = Dry.Struct { transform_keys(&:to_sym) }
end

require 'mirren/version'
require 'mirren/api'
require 'mirren/info'
require 'mirren/accounts'
require 'mirren/rigs'
require 'mirren/rentals'
require 'mirren/client'
