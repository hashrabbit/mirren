# ResultExt
# Provides a helpful method wrapper around Dry::Monad::Result objects
module ResultExt
  include Dry::Monads[:result]

  # ResultExt#fmap_left
  # Takes two arguments:
  #   a result, Success(T) | Failure(U)
  #   a map function, Fn(U) -> V
  # and returns:
  #   a result, Success(T) | Failure(V)
  # Works like fmap, but maps the Failure value to a new Failure value instead.
  # Success values are left unchanged
  def fmap_left(&map)
    self.or { Failure(map.call(_1)) }
  end

  # ResultExt#traverse
  # Takes two arguments:
  #   a result array, Success(Array(T)) | Failure(Err)
  #   a bind function, Fn(T) -> Success(U) | Failure(Err)
  # and returns:
  #   a result array, Success(Array(U)) | Failure(Err)
  # If bind returns Failure(Err) for any T in the array, we return Failure(Err)
  # If bind returns Success(U) for all T, we return Success(Array(U))
  def traverse(&bind)
    self.bind do |success_array_t|
      success_array_t.reduce(Success([])) do |result_array_u, t|
        result_array_u.bind do |success_array_u|
          bind.call(t).fmap do |success_u|
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
  #   If it's a value representing an error, we raise it in a wrapped exception
  def unwrap_result!
    case self
      in Success(success)
        success
      in Success(*success_rest)
        success_rest

      in Failure(Exception => err)
        raise err
      in Failure(other)
        raise Mirren::Error, other
      in Failure(*other_rest)
        raise Mirren::Error, other_rest
    end
  end
end
