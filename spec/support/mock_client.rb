class MockClient
  @@klasses = {}

  def initialize(endpoints_klass)
    @klass = @@klasses[endpoints_klass] ||= Class.new do
      include endpoints_klass
      attr_reader :request
      def initialize(request)
        @request = request
      end
    end
  end

  def call(request)
    @klass.new(request)
  end
end

