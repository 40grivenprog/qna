Rails.application.routes.draw do
  resources :questions do
    resources :answers, shallow: true
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
