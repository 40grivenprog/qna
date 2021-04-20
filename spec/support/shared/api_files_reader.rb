shared_examples_for 'API FileReadeable' do
  it 'returns url for attached files' do
    %w[url].each do |attr|
      expect(file_response[attr]).to eq rails_blob_url(record.files.first, only_path: true)
    end
  end
end
