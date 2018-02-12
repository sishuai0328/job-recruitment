Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :jobs do
      member do
        post :publish
        post :hide
      end
      resources :resumes
    end
  end


  resources :jobs do
    resources :resumes
  end

  namespace :account do
    resources :groups
  end

  resources :groups do
    member do
      post :join
      post :quit
    end
    resources :posts
  end

  root 'welcome#index'
end
