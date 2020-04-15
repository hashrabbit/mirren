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

module Mirren
  BaseStruct = Dry.Struct { transform_keys(&:to_sym) }
end

require 'mirren/version'
require 'mirren/errors'
require 'mirren/result_ext'
require 'mirren/api'
require 'mirren/info'
require 'mirren/accounts'
require 'mirren/rigs'
require 'mirren/rentals'
require 'mirren/client'
