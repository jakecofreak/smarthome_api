Rails.application.routes.draw do
  root 'smartthings#root'
  get '/leaving', to: 'smartthings#leaving'
  post '/lifecycle', to: 'smartthings#lifecycle'
  get '/garage/on', to: 'smartthings#garage_on'
  get '/garage/off', to: 'smartthings#garage_off'
  get '/subscriptions/new', to: 'smartthings#new_subscription'
end
