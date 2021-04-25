require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'POST #search' do
    subject { post :search, params: {body: "", type: "All" } }

    it 'should render search template' do
      subject
      expect(response).to render_template :search
    end
  end
end
