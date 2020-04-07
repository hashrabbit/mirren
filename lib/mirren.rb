require 'dry-struct'
require 'dry/monads'
Dry::Types.load_extensions(:monads)

module Types
  include Dry.Types()
  NilOrString = Types::Nil | Types::String
  FloatString = Types.Constructor(Float) { |v| v.to_f }
  IntString = Types.Constructor(Integer) { |v| v.to_i }
  YesBool = Types.Constructor(Bool) { |v| v.downcase == 'yes' }
  HashTypes = Types::String.enum('hash', 'kh', 'mh', 'gh', 'th')
end

module Monads
  include Dry::Monads[:result]

  # @traverse_results
  # Takes two arguments:
  #   a result array, Success(Array(T)) | Failure(Err)
  #   a bind function, Fn(T) -> Success(U) | Failure(Err)
  # and returns:
  #   a result array, Success(Array(U)) | Failure(Err)
  # If bind returns Failure(Err) for any T in the array, we return Failure(Err)
  # If bind returns Success(U) for all T in the array, we return Success(Array(U))
  def self.traverse_results(result_array_t, &bind)
    result_array_t.bind do |success_array_t|
      success_array_t.reduce(Monads::Success.new([])) do |result_array_u, t|
        result_array_u.bind do |success_array_u|
          bind.call(t).fmap do |success_u|
            success_array_u << success_u
          end
        end
      end
    end
  end

  def self.unwrap_result!(result)
    case result
      in Monads::Success(success)
        success
      in Monads::Success(*success_rest)
        success_rest

      in Monads::Failure(Exception => err)
        raise err
      in Monads::Failure(other)
        raise Mirren::Error.new(other)
      in Monads::Failure(*other_rest)
        raise Mirren::Error.new(other_rest)
    end
  end
end

module Mirren
  class Error < StandardError
  end

  class JsonError < Error
    def initialize(value)
      super("Error handling JSON: #{value}")
    end
  end

  class ClientError < Error
    def initialize(value)
      super("Client error: #{value}")
    end
  end

  class ApiError < Error
    def initialize(message)
      super("API Error: #{message}")
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
