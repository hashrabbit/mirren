class MockClient
  @@klasses = {}

  def initialize(endpoints_klass)
    @klass = @@klasses[endpoints_klass] ||= Class.new do
      include endpoints_klass
      attr_reader :request, :host, :api_key, :auth
      def initialize(request)
        @request = request
        @host = 'https://api.example.com'
        @api_key = 'api_key'
        @auth = stub_auth.new(api_key)
      end

      def stub_auth
        Struct.new(:api_key) do
          def call(*)
            ''
          end
        end
      end
    end
  end

  def call(request)
    @klass.new(request)
  end
end
