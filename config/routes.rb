InfoDebate::Application.routes.draw do

  namespace :admin do
    resources :users
  end

  root :to => 'pages#home'
  
  match '/about', :to => 'pages#about'
  
end
