shared_examples_for 'API LinkReadeable' do
  it 'returns url for attached links' do
    %w[url].each do |attr|
      expect(link_response[attr]).to eq link.send(attr).as_json
    end
  end
end
