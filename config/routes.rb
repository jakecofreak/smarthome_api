Rails.application.routes.draw do
  get '/leaving', to: 'smartthings#leaving'
  post '/lifecycle', to: 'smartthings#lifecycle'
  get '/garage/on', to: 'smartthings#garage_on'
  get '/garage/off', to: 'smartthings#garage_off'
end
