Rails.application.routes.draw do
  get 'shortener/index'
  get '/links', to: 'links#index'

  get '/:id', to: 'shortener#unshorten'

  get '/links/new', to: 'links#new'
  post '/links', to: 'links#create'
  get '/links/:id', to: 'links#display'

  root 'shortener#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end