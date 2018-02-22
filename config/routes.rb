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
    resources :categories do

    end
    resources :locations
  end

  # 收藏／取消收藏工作
  resources :jobs do
    member do
      post :favorites #因与下面的favorite同名，出现routes错误，此处改名处理
      post :unfavorite
    end
    collection do
      get :search
    end
    resources :resumes
  end



  # 我收藏的工作
  namespace :favorite do #此处即为上面所说变量重名的问题
    resources :jobs
  end

  # 我的讨论组和我的文章
  namespace :account do
    resources :groups do
      resources :posts
    end
    resources :posts
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
