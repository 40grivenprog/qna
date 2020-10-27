Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"
  concern :voteable do
    member do
      post :vote_for
      post :vote_against
      delete :cancel_vote
    end
  end

  resources :questions, concerns: [:voteable] do
    resources :answers, concerns: [:voteable], shallow: true do
      member do
        post :mark_as_best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
