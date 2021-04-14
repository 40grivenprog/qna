 Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', confirmations: 'confirmations' }
  root to: "questions#index"
  concern :voteable do
    member do
      post :vote_for
      post :vote_against
      delete :cancel_vote
    end
  end

  concern :commented do
    member do
      post :make_comment
    end
  end

  resources :questions, concerns: [:voteable, :commented] do
    resources :answers, concerns: [:voteable, :commented], shallow: true do
      member do
        post :make_comment
        post :mark_as_best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :other, on: :collection
      end

      resources :questions do
        resources :answers, shallow: true
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
