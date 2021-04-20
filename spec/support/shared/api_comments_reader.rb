shared_examples_for 'API CommentReadeable' do
  it 'returns all public fields for comment' do
    %w[id commentable_type commentable_id user_id body created_at updated_at].each do |attr|
      expect(comment_response[attr]).to eq comment.send(attr).as_json
    end
  end
end
