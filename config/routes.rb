Rails.application.routes.draw do
  get '/leaving', to: 'smartthings#leaving'

  post '/lifecycle', to: 'smartthings#lifecycle'
end
