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
end
