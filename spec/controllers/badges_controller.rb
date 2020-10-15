require 'rails_helper'

RSpec.describe BadgesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  describe 'GET #index' do
    before { login(user) }
    before { get :index }

    let!(:badge) { FactoryBot.create(:badge, user: user) }

    it 'returns an array of all user\'s badges' do
      expect(assigns(:badges)).to match_array [badge]
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end


  end
end
