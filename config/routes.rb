Rails.application.routes.draw do
  post 'logs', to: 'smartthings#logs'
  get 'test', to: 'smartthings#test_endpoint'
end
