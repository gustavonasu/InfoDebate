InfoDebate::Application.routes.draw do

  namespace :admin do
    resources :users, :forums, :forum_threads do
      member do
        get 'change_status/:status_action(/:call_from)', :action => 'change_status', :as => 'change_status'
        get 'show_modal/:call_from', :action => 'show_modal', :as => 'show_modal'
      end
    end
    
    resources :comments do
      member do
        get 'change_status/:status_action(/:call_from)', :action => 'change_status', :as => 'change_status'
        get 'show_modal/:call_from', :action => 'show_modal', :as => 'show_modal'
        get 'answers(/:div_class)', :action => 'answers', :as => 'answers'
        get 'complaints(/:div_class)', :controller => 'complaints', :action => 'complaints', :as => 'complaints'
      end
    end
    
    resources :complaints do
      member do
        get 'change_status/:status_action(/:call_from)', :action => 'change_status', :as => 'change_status'
        get 'show_modal/:call_from', :action => 'show_modal', :as => 'show_modal'
      end
    end
  end

  root :to => 'pages#home'
  
  match '/about', :to => 'pages#about'
  
end
