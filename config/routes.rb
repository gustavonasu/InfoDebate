InfoDebate::Application.routes.draw do

  change_status_actions = lambda do
    put 'change_status/:status_action', :action => 'change_status', :as => 'change_status'
  end

  show_modal_get = lambda do
    get 'show_modal', :action => 'show_modal', :as => 'show_modal'
  end

  namespace :admin do
    resources :users, :forums, :forum_threads do
      member do
        change_status_actions.call
        show_modal_get.call
      end
    end
    
    resources :comments do
      member do
        change_status_actions.call
        show_modal_get.call
        get 'answers(/:div_class)', :action => 'answers', :as => 'answers'
        get 'complaints(/:div_class)', :controller => 'complaints', :action => 'complaints', :as => 'complaints'
      end
    end
    
    resources :complaints do
      member do
        change_status_actions.call
        show_modal_get.call
      end
    end
  end

  root :to => 'pages#home'
  
  match '/about', :to => 'pages#about'
  
end
