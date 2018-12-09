Rails.application.routes.draw do
  post 'logs', to: 'smartthings#logs'
end
