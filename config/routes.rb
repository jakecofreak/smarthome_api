Rails.application.routes.draw do
  # smarthings routes
  root 'smartthings#root'
  get '/leaving', to: 'smartthings#leaving'
  post '/lifecycle', to: 'smartthings#lifecycle'
  get '/garage/on', to: 'smartthings#garage_on'
  get '/garage/off', to: 'smartthings#garage_off'
  get '/subscriptions/new', to: 'smartthings#new_subscription'

  # plex routes
  post '/plex', to: 'plex#notify'
end
