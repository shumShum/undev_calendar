UndevCalendar::Application.routes.draw do
  
  root :to => 'dashboard#index'
  get '/index' => 'dashboard#index'

end
