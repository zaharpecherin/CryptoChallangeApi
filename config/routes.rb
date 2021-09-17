Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, path: '/', constraints: { format: 'json' } do
    namespace :v1 do
      get 'list_of_tickers', to: 'base#list_of_tickers'
    end
  end
end
