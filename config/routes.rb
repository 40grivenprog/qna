Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"
  resources :questions do
    resources :answers, shallow: true do
      member do
        post :mark_as_best
      end
    end
  end

  resources :attachments, only: :destroy
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
