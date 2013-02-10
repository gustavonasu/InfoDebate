InfoDebate::Application.routes.draw do

  namespace :admin do
    resources :users, :forums, :forum_threads
  end

  root :to => 'pages#home'
  
  match '/about', :to => 'pages#about'
  
end
