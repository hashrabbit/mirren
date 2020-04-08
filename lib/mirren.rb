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

# ResultExt
# Provides a helpful wrapper around Dry::Monad::Result objects for common operations
module ResultExt
  include Dry::Monads[:result]

  # ResultExt#fmap_left
  # Takes two arguments:
  #   a result, Success(T) | Failure(U)
  #   an fmap function, Fn(U) -> V
  # and returns:
  #   a result, Success(T) | Failure(V)
  # Works like fmap, but maps the Failure value to a new Failure value instead.
  # Success values are left unchanged
  def fmap_left(&fmap)
    self.or { |err| Failure(fmap(err)) }
  end

  # ResultExt#traverse
  # Takes two arguments:
  #   a result array, Success(Array(T)) | Failure(Err)
  #   a bind function, Fn(T) -> Success(U) | Failure(Err)
  # and returns:
  #   a result array, Success(Array(U)) | Failure(Err)
  # If bind returns Failure(Err) for any T in the array, we return Failure(Err)
  # If bind returns Success(U) for all T in the array, we return Success(Array(U))
  def traverse(&bind)
    self.bind do |success_array_t|
      success_array_t.reduce(Success([])) do |result_array_u, t|
        result_array_u.bind do |success_array_u|
          bind.(t).fmap do |success_u|
            success_array_u << success_u
          end
        end
      end
    end
  end

  # ResultExt#unwrap_result!
  # Unwraps the underlying value.
  # If it's a Success, the successful value is returned
  # If it's a Failure, we match on the kind of Failure:
  #   If it's already an exception, we just raise it
  #   If it's a value representing an error, we wrap it in an exception and raise it
  def unwrap_result!
    case self
      in Success(success)
        success
      in Success(*success_rest)
        success_rest

      in Failure(Exception => err)
        raise err
      in Failure(other)
        raise Mirren::Error.new(other)
      in Failure(*other_rest)
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

  class UnmarshalError < Error
    def initialize(message)
      super("Unmarshalling Error: #{message}")
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
