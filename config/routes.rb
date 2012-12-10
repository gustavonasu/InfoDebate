InfoDebate::Application.routes.draw do

  namespace :admin do
    resources :commenters
  end

  root :to => 'pages#home'
  
  match '/about', :to => 'pages#about'
  
end
