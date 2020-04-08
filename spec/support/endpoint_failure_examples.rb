RSpec.shared_examples 'endpoints failing with error' do |endpoint_list, error|
  endpoint_list.each_pair do |method, kwargs|
    specify "#{method} returns a Failure of #{error}" do
      result = client.send(method, **kwargs)
      expect(result).to be_failure
      expect(result.flip.value!).to be_an error
    end

    specify "#{method}! raises a #{error}" do
      expect { client.send("#{method}!", **kwargs) }.to raise_error(error)
    end
  end
end

RSpec.shared_context 'endpoint failures' do |endpoint_list|
  context 'when the api response indicates a failed request' do
    let(:response_success?) { false }
    let(:response_data) { "{\"message\": \"Request failed\"}" }

    it_behaves_like 'endpoints failing with error', endpoint_list, Mirren::ApiError
  end

  context 'when the underlying request returns bad json' do
    let(:response_success?) { true }
    let(:response_data) { 'bad json' }

    it_should_behave_like 'endpoints failing with error', endpoint_list, Mirren::JsonError
  end

  context 'when the rest client throws an exception with a response code' do
    before do
      allow(request).to(receive(:call)).and_raise RestClient::ImATeapot
    end

    it_should_behave_like 'endpoints failing with error', endpoint_list, Mirren::ApiError
  end

  context 'when the underlying request throws an error without a response code' do
    before do
      allow(request).to(receive(:call)).and_raise RestClient::Exception
    end

    it_should_behave_like 'endpoints failing with error', endpoint_list, Mirren::ClientError
  end
end
