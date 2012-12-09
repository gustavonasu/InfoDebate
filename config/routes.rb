InfoDebate::Application.routes.draw do
  resources :commenters

  root :to => 'pages#home'
  
  match '/about', :to => 'pages#about'
  
end
