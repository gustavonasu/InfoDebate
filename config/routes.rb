InfoDebate::Application.routes.draw do

  namespace :admin do
    resources :users, :forums, :forum_threads do
      member do
        get 'change_status/:status_action', :action => 'change_status', :as => 'change_status'
      end
    end
  end

  root :to => 'pages#home'
  
  match '/about', :to => 'pages#about'
  
end
