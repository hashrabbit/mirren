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

  # @result_list_bind
  # Takes two arguments:
  #   a result list, Success(Array(T)) | Failure(Err)
  #   a bind function, Fn(T) -> Success(U) | Failure(Err)
  # and returns:
  #   a result list, Success(Array(U)) | Failure(Err)
  # If bind returns Failure(Err) for any T in the list, we return Failure(Err)
  # If bind returns Success(U) for all T in the list, we return Success(Array(U))
  def self.result_list_bind(result_list_t, &bind)
    result_list_t.bind do |success_list_t|
      success_list_t.reduce(Monads::Success.new([])) do |result_list_u, t|
        result_list_u.bind do |success_list_u|
          bind.call(t).fmap do |success_u|
            success_list_u << success_u
          end
        end
      end
    end
  end
end

module Mirren
  class MirrenError < StandardError
    def self.unwrap!(result)
      case result
        in Monads::Success(success)
        in Monads::Failure(MirrenError => e)
          raise e
        in Monads::Failure(other)
          raise GenericError.new(other)
      end
    end
  end

  class GenericError < MirrenError
    def initialize(value)
      super("Error: #{value}")
    end
  end

  class ApiError < MirrenError
    def initialize(message)
      super("API Error: #{message}")
    end
  end

  class ParamsError < MirrenError
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
