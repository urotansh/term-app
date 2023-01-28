Rails.application.routes.draw do

  # ゲストログイン用ルーティング
  devise_scope :user do
    post "users/guest_sign_in", to: "public/sessions#guest_sign_in"
  end
  
  
  # Deviseルーティング
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }
  
  
  # 管理者機能
  namespace :admin do
    get "/", to: "homes#top"
    
    # 投稿管理機能
    resources :notes, only: [:index, :show, :destroy] do
      # コメント管理機能
      resources :note_comments, only: [:destroy] do
        collection do
          get ":id", to: "note_comments#index"
        end
      end
    end
    
    # ユーザー管理機能
    resources :users, param: :name, only: [:index, :show, :edit, :update] do
      collection do
        get "search", to: "users#search"
      end
    end
    
  end
  
  
  # ユーザー機能
  scope module: :public do
    root to: "homes#top"
    # TODO:Aboutページ実装
    # get "about", to: "homes#about"
    
    # 投稿機能
    resources :notes do
      # コメント機能
      resources :note_comments, only: [:create, :destroy, :index] do
        collection do
          get ":id", to: "note_comments#index"
        end
      end
      # いいね機能
      resource :favorites, only: [:create, :destroy]
    end
    
    # ユーザー設定機能
    resources :users, param: :name, path: '/', only: [:show] do
      collection do
        get   "settings/profile", to: "users#edit"
        patch "settings/profile", to: "users#update"
        get   "quit",             to: "users#quit"
        patch "withdraw",         to: "users#withdraw"
      end
      
      # フォロー機能
      resource :relationships, only: [:create, :destroy]
      member do
        get "following", to: "users#following"
        get "followers", to: "users#followers"
      end
    end
    
    
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
