Rails.application.routes.draw do
  get 'shortener/index'
  get '/:id', to: 'shortener#unshorten'
  post '/shorten', to: 'shortener#shorten'
  root 'shortener#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
