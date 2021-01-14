Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # This routes the root of the URL
  root 'api/v1/ingredients#search'

  namespace :api do
    namespace :v1 do
      post 'authenticate', to: 'authentication#authenticate'
      get 'scan', to: 'scan#scan'

      resources :ingredients do
        # Member is used when you want to use id before ie /ingredients/:id/log
        member do
          get 'log'
        end
        # Collection is used if you just want to add a new route ie /ingredients/search
        collection do
          get 'search'
        end
      end
      resources :users do
        collection do
          get 'search'
        end
      end
    end
  end
end
