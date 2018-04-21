Rails.application.routes.draw do
  get '/links', to: 'links#index'
  post '/links', to: 'links#create'
  get '/links/new', to: 'links#new'
  get '/links/:id', to: 'links#display'

  post '/shorten', to: 'shortener#shorten'
  get '/:id', to: 'shortener#unshorten'

  root 'links#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end