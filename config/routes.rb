Rails.application.routes.draw do
  resources :produtos do
    get 'venda', to: 'venda#index'
    post 'venda', to: 'venda#vender'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'produtos#index'
end
