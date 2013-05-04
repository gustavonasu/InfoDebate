InfoDebate::Application.routes.draw do

  change_status_get = lambda do
    get 'change_status/:status_action(/:call_from)', :action => 'change_status', :as => 'change_status'
  end

  show_modal_get = lambda do
    get 'show_modal/:call_from', :action => 'show_modal', :as => 'show_modal'
  end

  namespace :admin do
    resources :users, :forums, :forum_threads do
      member do
        change_status_get.call
        show_modal_get.call
      end
    end
    
    resources :comments do
      member do
        change_status_get.call
        show_modal_get.call
        get 'answers(/:div_class)', :action => 'answers', :as => 'answers'
        get 'complaints(/:div_class)', :controller => 'complaints', :action => 'complaints', :as => 'complaints'
      end
    end
    
    resources :complaints do
      member do
        change_status_get.call
        show_modal_get.call
      end
    end
  end

  root :to => 'pages#home'
  
  match '/about', :to => 'pages#about'
  
end
