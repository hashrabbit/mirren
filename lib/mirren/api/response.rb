module Mirren
  module Api
    class Response < BaseStruct
      include Dry::Monads[:result]

      Status = Class.new(BaseStruct) do
        attribute? :id, Types::IntString
        attribute? :success, Types::Bool
        attribute :message, Types::String
      end
      Single = Types::JSON::Hash
      Multi = Types.Array(Single)

      attribute :success, Types::Bool
      attribute :data, Status | Single | Multi

      def success?
        return success && data[:success] if data.is_a?(Status)

        success
      end

      def to_result
        success? ? Success(data) : Failure(ApiError.new(data[:message]))
      end
    end
  end
end
